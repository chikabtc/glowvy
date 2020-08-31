// Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (_tabController.index == 1)
//                           Container(
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 21, bottom: 10, left: 16),
//                               child: DynamicText(
//                                 S.of(context).trendingKorea,
//                                 style: kBaseTextStyle.copyWith(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ),
//                         if (_tabController.index == 1)
//                           Container(
//                             color: kDefaultBackground,
//                             child: productModel.showProductList(
//                                 isNameAvailable: true,
//                                 isListView: false,
//                                 future: getProductByTagTrending,
//                                 onLoadMore: onLoadMore),
//                           ),
//                         if (_tabController.index == 0)
//                           !isSurveyFinished
//                               ? PersonalSurvey(
//                                   surveys: surveys,
//                                   onSurveyFinish: () {
//                                     setState(() {
//                                       isSurveyFinished = true;
//                                       isGenerating = true;
//                                       Future.delayed(
//                                           const Duration(milliseconds: 2000),
//                                           () {
//                                         setState(() {
//                                           isGenerating = false;
//                                           // Here you can write your code for open new view
//                                         });
//                                       });
//                                     });
//                                   })
//                               : _generatePersonalizedPackages(),
//                       ],
//                     ),

// Container(
//   child: Padding(
//     padding: const EdgeInsets.only(
//         top: 21, bottom: 10, left: 16),
//     child: DynamicText(
//       S.of(context).trendingKorea,
//       style: kBaseTextStyle.copyWith(
//           fontSize: 15, fontWeight: FontWeight.w600),
//     ),
//   ),
// ),
// if (_tabController.index == 1)
//   Container(
//     color: kDefaultBackground,
//     child: productModel.showProductList(
//         isNameAvailable: true,
//         isListView: false,
//         future: getProductByTagTrending,
//         onLoadMore: onLoadMore),
//   ),
// if (_tabController.index == 0)
//   !isSurveyFinished
//       ? PersonalSurvey(
//           surveys: surveys,
//           onSurveyFinish: () {
//             setState(() {
//               isSurveyFinished = true;
//               isGenerating = true;
//               Future.delayed(
//                   const Duration(milliseconds: 2000),
//                   () {
//                 setState(() {
//                   isGenerating = false;
//                   // Here you can write your code for open new view
//                 });
//               });
//             });
//           })
//       : _generatePersonalizedPackages(),
