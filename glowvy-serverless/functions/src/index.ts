/* eslint-disable no-prototype-builtins */
/* eslint-disable no-var */
/* eslint-disable no-console */

import { WebClient } from '@slack/web-api';

import functions = require('firebase-functions');

import admin = require('firebase-admin');
import algolia = require('algoliasearch');
import math = require('../node_modules/@types/mathjs');
import rankingHelper = require('./helpers/ranking');
import utils = require('./helpers/utils')

const crypto = require('crypto');
const serviceAccount = require('../lib/service_key.json');

const client = algolia.default('50G6MO803G', 'ab5eb7ec7552bb7865f3819a2b08f462');
const cosmeticsIndex = client.initIndex('cosmetics'); //
const { firestore } = admin;
const productsFile = require('./helpers/files/products.json');
const reviewsFile = require('./helpers/files/reviews.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://glowvy-b6cf4.firebaseio.com',
});
const runtimeOpts = {
  timeoutSeconds: 540,
  memory: '1GB' as '1GB',
};
const db = admin.firestore();

function getAverageRating(reviewMeta: any, newReviewRating: number) {
  if (reviewMeta.review_count === 0) {
    return 0;
  }
  return (reviewMeta.average_rating * reviewMeta.review_count + newReviewRating) / (reviewMeta.review_count);
}

exports.updateProductCount = functions.region('asia-east2').firestore
  .document('/products/{documentId}')
  .onDelete(async (snap: functions.firestore.QueryDocumentSnapshot, context: any) => {
    await db.collection('product').doc('product_counter').update({
      count: admin.firestore.FieldValue.increment(-1),
    });
  });

exports.onCosmeticsRequest = functions.region('asia-east2').firestore
  .document('/users/{userId}/{cosmetics_requests}/{documentId}')
  .onCreate(async (snap: functions.firestore.QueryDocumentSnapshot, context: any) => {
    const requestedCosmetics = snap.data();
    const web = new WebClient(functions.config().slack.token);
    try {
      // Use the `chat.postMessage` method to send a message from this app
      await web.chat.postMessage({
        channel: 'C01D94HK7EU',
        text: `New cosmetics has been requested!
        name: ${requestedCosmetics?.name}
        category: ${requestedCosmetics?.category}
        brand: ${requestedCosmetics?.brand}\n`,
      });
    } catch (error) {
      console.log(error);
    }
    // send slack notification about this new product
  });

exports.algoliaProductSync = functions.region('asia-east2')
  .firestore.document('products/{documentId}').onWrite(async (change, _context) => {
    const oldData = change.before;
    const newData = change.after;
    const product = newData.data();
    const objectID = newData.id; // <-- prop name is important
    const algoliaRecrod = {
      name: product?.name,
      official_price: product?.official_price,
      sprice: product?.sprice,
      sid: product?.sid,
      objectID: product?.sid,
      description: product?.description,
      volume: product?.volume,
      hazard_level: product?.hazard_level,
      // 'sdescription': product.sdescription,
      brand: product?.brand,
      category: product?.category,
      tags: product?.tags,
      review_metas: product?.review_metas,
      thumbnail: product?.thumbnail,
    };
    // creating

    if (!oldData.exists && newData.exists) {
      console.log('product is created');
      utils.updateAvailableBrandCategories(db, product);
      return cosmeticsIndex.saveObject(algoliaRecrod);
      // deleting
    } if (!newData.exists && oldData.exists) {
      console.log('product is deleted');
      return cosmeticsIndex.deleteObject(objectID);
    }
    console.log('product is updated');
    return cosmeticsIndex.saveObject(algoliaRecrod);
  });

exports.onReviewUpdate = functions.region('asia-east2')
  .firestore.document('reviews/{documentId}').onWrite(async (change, _context) => {
    const oldData = change.before;
    const newData = change.after;
    const oldReview = oldData.data();
    const newReview = newData.data();
    console.log(`oldReview: ${oldReview?.product?.sid}`);
    console.log(`newReview: ${newReview?.product?.sid}`);

    const productSnap = await db
      .collection('products').where('sid', '==', newData?.exists ? newReview?.product?.sid : oldReview?.product?.sid).get();
    if (productSnap?.empty) {
      console.log('no matching documents');
      return;
    }

    const productDoc = productSnap.docs[0];
    const product = productSnap.docs[0].data();
    console.log('product: ', product?.sid);
    const skinType = newData?.exists ? newReview?.user.skin_type_en : oldReview?.user.skin_type_en;
    const reviewMeta = product?.review_metas[skinType];
    const generalReviewMeta = product?.review_metas.all;

    // creating review
    if (!oldData.exists && newData.exists) {
      console.log('review is created');

      reviewMeta.review_count += 1;
      generalReviewMeta.review_count += 1;

      const newRating = getAverageRating(reviewMeta, newReview?.rating);
      const newGeneralRating = getAverageRating(generalReviewMeta, newReview?.rating);

      // update the total review count
      await db.collection('reviews').doc('review_counter').update({
        count: firestore.FieldValue.increment(1),
      });
      await productDoc.ref.update({
        'review_metas.all.review_count': firestore.FieldValue.increment(1),
        'review_metas.all.average_rating': newGeneralRating,
        'review_metas.all.ranking_score': rankingHelper.calculateRankingScore(
          product,
          newGeneralRating,
          'all',
        ),
        [`review_metas.${skinType}.review_count`]: firestore.FieldValue.increment(1),
        [`review_metas.${skinType}.average_rating`]: newRating,
        [`review_metas.${skinType}.ranking_score`]: rankingHelper.calculateRankingScore(
          product,
          newRating,
          skinType,
        ),
      });

      // deleting review
    } else if (!newData.exists && oldData.exists) {
      console.log('review is deleted');

      reviewMeta.review_count -= 1;
      generalReviewMeta.review_count -= 1;

      const newRating = getAverageRating(reviewMeta, -oldReview?.rating);
      const newGeneralRating = getAverageRating(generalReviewMeta, -oldReview?.rating);
      // update the total review count
      await db.collection('reviews').doc('review_counter').update({
        count: firestore.FieldValue.increment(-1),
      });
      await productDoc.ref.update({
        'review_metas.all.review_count': firestore.FieldValue.increment(-1),
        'review_metas.all.average_rating': newGeneralRating,
        'review_metas.all.ranking_score': rankingHelper.calculateRankingScore(
          product,
          newGeneralRating,
          'all',
        ),
        [`review_metas.${skinType}.review_count`]: firestore.FieldValue.increment(-1),
        [`review_metas.${skinType}.average_rating`]: newRating,
        [`review_metas.${skinType}.ranking_score`]: rankingHelper.calculateRankingScore(
          product,
          newRating,
          skinType,
        ),
      });
    }
    // return cosmeticsIndex.saveObject({ objectID, ...algoliaRecrod });
  });
function parsedSignedRequest(signedRequest) {
  // 1. parse the signedRequest
  const parts = signedRequest.split('.');
  const sig = window.atob(parts[0]);
  const payload = window.atob(parts[1]);
  console.log(sig, JSON.parse(payload));
  const appSecret = '67d922662897913f932b417e0b44f13b';
  // TODO(parker): might need to decode the data before passing them into hmac decoder

  // 2. confirm the signature
  const expectedSig = crypto.createHmac('sha256', appSecret).update(payload).digest().toString('base64');
  if (sig !== expectedSig) {
    console.log('Bad Signed JSON signature!');
    return null;
  }

  // $expected_sig = hash_hmac('sha256', $payload, $secret, $raw = true);

  return JSON.parse(payload);
}

exports.onDataDeletionRequest = functions.region('asia-east2').https.onRequest(async (req, res) => {
  // 1. parse the signed request and get the userID
  const signedRequest = req;
  const data = parsedSignedRequest(signedRequest);
  const userId = data?.user_id;

  // 2. delete the user info on the firestore
  const snap = await db
    .collection('users').where('facebook_user_id', '==', userId).get();
  if (snap?.empty) {
    console.log('no matching documents');
    return;
  }

  const userDoc = snap.docs[0];
  const user = userDoc.data();

  const confirmationCode = user.uid; // unique code for the deletion request

  // https://asia-east2-glowvy-b6cf4.cloudfunctions.net/checkDeletionRequestStatus?id=yyCpqGf5PRb9VGyoL6pdJDdl3fH3
  const statusUrl = `https://asia-east2-glowvy-b6cf4.cloudfunctions.net/checkDeletionRequestStatus?id${confirmationCode}`; //
  userDoc.ref.delete().then(() => console.log('deleted facebook user'));

  // URL for checking the user status on firestore && URL to track the deletion

  res.json({
    url: statusUrl,
    confirmationCode,
  });
});

exports.checkDeletionRequestStatus = functions.region('asia-east2').https.onRequest(async (req, res) => {
  const uid = req.query.id;
  const snap = await db
    .collection('users').where('uid', '==', uid).get();
  var statusMessage = '';
  if (snap?.empty) {
    statusMessage = "it's successfully deleted";
  } else {
    statusMessage = 'deletion request has failed. Please contact Glowvy';
  }
  res.json({
    status: statusMessage,
  });
});
