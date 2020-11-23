function calculateRating(reviewMeta, newReviewRating) {
    return (reviewMeta.average_rating * reviewMeta.review_count + newReviewRating) / (reviewMeta.review_count + 1);
}

function calculateRankingScore(
    product,
    averageRating,
    skinType,
) {
    const reviewsMeta = product.reviews_meta[skinType];
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
    const reviewPoint = reviewsMeta.review_count < 50 ? 1 : math.log(reviewsMeta.review_count, 50);

    const score = reviewPoint * averageRating + hazardScore;

    // console.log(skinType, 'ranking score', score.toFixed(3).slice(0, -1));
    return score.toFixed(3).slice(0, -1);
}

module.exports = {
    calculateRankingScore: calculateRankingScore,
    calculateRating: calculateRating
}