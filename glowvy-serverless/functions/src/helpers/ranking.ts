const math = require('mathjs');
// 1. Review Rating
//    reviewers have 4 keywords to select:
//    1. dry
//    2. oily
//    3. neutral
//    4. complex

// 2. Ingredient Safety Hazard score
//    if hazard score is 1, add 0.5
//    if hazard score is 2, minus 0.5
//    if hazard score is 3, minus 1
// 3. Customer Review Count
//    divde the total review count by 100
//    if a product has a review of 350, then its review score will be 3.5

export function calculateRankingScore(
  product: any,
  averageRating: number,
  skinType: string,
) {
  const reviewMetas = product.review_metas[skinType];
  if (reviewMetas.review_count === 0) { return 0; }
  let hazardScore = 0;
  switch (product.hazard_score) {
    case 3:
      hazardScore = -1;
      break;
    case 2:
      hazardScore = -0.5;
      break;
    case 1:
      hazardScore = 0.5;
      break;
    default:
      break;
  }
  const reviewPoint = reviewMetas.review_count < 50 ? 1 : math.log(reviewMetas.review_count, 50);

  const score = reviewPoint * averageRating + hazardScore;

  // console.log(skinType, 'ranking score', score.toFixed(3).slice(0, -1));
  return Number(score.toFixed(3).slice(0, -1));
}

export default calculateRankingScore;
