/* eslint-disable no-prototype-builtins */
import algoliasearch = require('algoliasearch');

const fs = require('fs');
const path = require('path');

const directoryPath = path.join(__dirname, 'files');
export function sleep(ms: any) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

export function uploadJsonFiles(db: any, file: any, fileName: String) {
  fs.readdir(directoryPath, (err: any, files: any) => {
    if (err) {
      return console.log(`Unable to scan directory: ${err}`);
    }

    file.forEach((obj: any) => {
      obj.created_at = Date.now();
      const { ingredients } = obj;
      delete obj.ingredients;
      // console.log(obj)
      db
        .collection(fileName)
        .add(obj)
        .then((res: any) => {
          console.log('Document written');
          // ingredients.forEach(async (objt: any) => {
          //   await res.collection('ingredients').add(objt).then(() => console.log('uploaded ingredient'));
          // });
        })
        .catch((error: any) => {
          console.error('Error adding document: ', error);
        });
    });
    return 0;
  });
}

export async function updateAvailableBrandCategories(db, product): Promise<void> {
  // 1. get the brand doc
  const brandSnap = await db.collection('brands').where('id', '==', product.brand.id).get();
  const brandDoc = brandSnap.docs[0];
  const brand = brandDoc.data();
  console.log(`brand name ${brand.name}`);
  const firstCateIds = [] as any;
  const secondCateIds = [] as any;
  const thirdCateIds = [] as any;

  const prodCate = product.category;
  if (brand.hasOwnProperty('categories')) {
    const brandCategories = brand.categories;
    for (const brandCate of brand.categories) {
      firstCateIds.push(brandCate.id);
      for (const secondCate of brandCate.second_categories) {
        secondCateIds.push(secondCate.id);
        for (const thirdCate of secondCate.third_categories) {
          thirdCateIds.push(thirdCate.id);
        }
      }
    }
    console.log(`${firstCateIds}\n${secondCateIds}\n${thirdCateIds}`);
    // 1. if the first category id is not included, then add the whole category
    if (!firstCateIds.includes(prodCate.first_category_id)) {
      console.log('first category missing');

      const category = {
        id: prodCate.first_category_id,
        name: prodCate.first_category_name,
        second_categories: [{
          id: prodCate.second_category_id,
          name: prodCate.second_category_name,
          third_categories: [{
            id: prodCate.third_category_id,
            name: prodCate.third_category_name,
          }],
        }],
      };
      brandCategories.push(category);
    } else if (!secondCateIds.includes(prodCate.second_category_id)) {
      console.log('second category missing');
      const firstCateIndex = brandCategories.findIndex((cate) => cate.id === prodCate.first_category_id);
      console.log(firstCateIndex);
      const firstCate = brandCategories[firstCateIndex];
      console.log(firstCate);

      firstCate.second_categories.push({
        id: prodCate.second_category_id,
        name: prodCate.second_category_name,
        third_categories: [{
          id: prodCate.third_category_id,
          name: prodCate.third_category_name,
        }],
      });

      brandCategories[firstCateIndex] = firstCate;
    } else if (!thirdCateIds.includes(prodCate.third_category_id)) {
      console.log('third category missing');

      const firstCateIndex = brandCategories.findIndex((cate) => cate.id === prodCate.first_category_id);
      const firstCate = brandCategories[firstCateIndex];
      const secondCateIndex = firstCate.second_categories.findIndex((cate) => cate.id === prodCate.second_category_id);
      const secondCate = brandCategories[firstCateIndex].second_categories[secondCateIndex];

      secondCate.third_categories.push({
        id: prodCate.third_category_id,
        name: prodCate.third_category_name,
      });
      firstCate.second_categories[secondCateIndex] = secondCate;
      brandCategories[firstCateIndex] = firstCate;
    }
    brandDoc.ref.update({
      categories: brandCategories,
    }).then(() => console.log('added category'));
  } else {
    console.log('no categories available on the brand doc');
    brand.categories = [];
    const category = {
      id: prodCate.first_category_id,
      name: prodCate.first_category_name,
      second_categories: [{
        id: prodCate.second_category_id,
        name: prodCate.second_category_name,
        third_categories: [{
          id: prodCate.third_category_id,
          name: prodCate.third_category_name,
        }],
      }],
    };
    const categories = [] as any;
    categories.push(category);
    console.log(categories);
    brandDoc.ref.update({
      categories,
    }).then(() => console.log('added category'));
  }
}

export async function updateCategoryProductCount(db, productJson, incrementBy) {
  const snap = await db.collection('categories').where('id', '==', productJson.category.first_category_id).get();
  const categoryDoc = snap.docs[0];
  const category = snap.docs[0].data();
  const subCategories = category.sub_categories;
  if (productJson.category.first_category_id !== undefined) {
    // if the count is zero, don't decrement

    if (category.hasOwnProperty('grand_total_count')) {
      if (category.grand_total_count !== 0 || incrementBy !== -1) {
        category.grand_total_count += incrementBy;
      }
    } else {
      category.grand_total_count = 1;
    }

    // find the subcategories the product belongs to
    if (subCategories != null) {
      if (productJson.category.second_category_id != null) {
        const secondCate = category.sub_categories.find((cate) => cate.id === productJson.category.second_category_id);
        const index = category.sub_categories.findIndex((cate) => secondCate.id === cate.id);
        if (subCategories[index].hasOwnProperty('grand_total_count')) {
          // if the count is zero, don't decrement
          if (subCategories[index].grand_total_count !== 0 || incrementBy !== -1) {
            subCategories[index].grand_total_count += incrementBy;
          }
        } else {
          subCategories[index].grand_total_count = 1;
        }

        if (productJson.category.third_category_id != null) {
          const thirdCategory = secondCate.sub_categories.find((cate) => cate.id === productJson.category.third_category_id);
          const thirdIndex = secondCate.sub_categories.findIndex((cate) => thirdCategory.id === cate.id);
          // eslint-disable-next-line no-plusplus
          subCategories[index].sub_categories[thirdIndex].grand_total_count++;

          if (subCategories[index].sub_categories[thirdIndex].hasOwnProperty('grand_total_count')) {
            // if the count is zero, don't decrement

            if (subCategories[index].sub_categories[thirdIndex].grand_total_count !== 0 || incrementBy !== -1) {
              subCategories[index].sub_categories[thirdIndex].grand_total_count += incrementBy;
            }
          } else {
            subCategories[index].sub_categories[thirdIndex].grand_total_count = 1;
          }

          // console.log(thirdCategory)
        }
      }
    }
    // console.log(subCategories)

    await categoryDoc.ref.update({
      grand_total_count: category.grand_total_count,
      sub_categories: subCategories,
    }).then(() => console.log('holooo'));
  }
}
export async function updateBrandProductCounter(db, productJson, incrementBy) {
  const snap = await db.collection('brands').where('id', '==', productJson.brand.id).get();
  const brandDoc = snap.docs[0];
  const count = brandDoc.data().grand_total_count + incrementBy;
  brandDoc.ref.update({
    grand_total_count: count,
  }).then(() => console.log('incremented'));
}

export async function incrementProductCount(db, firestore) {
  await db.collection('product').doc('product_counter').update({
    count: firestore.FieldValue.increment(1),
  });
}
export async function decrementroductCount(db, firestore) {
  await db.collection('product').doc('product_counter').update({
    count: firestore.FieldValue.increment(-1),
  });
}

export function getAverageRating(reviewMeta: any, newReviewRating: number) {
  if (reviewMeta.review_count === 0) {
    return 0;
  }
  return (reviewMeta.average_rating * (reviewMeta.review_count - 1) + newReviewRating) / (reviewMeta.review_count);
}
