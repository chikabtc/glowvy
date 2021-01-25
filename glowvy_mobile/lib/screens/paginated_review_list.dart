import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/product/review_model.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/screens/detail/review_card.dart';
import 'package:Dimodo/screens/error_indicator.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class PaginatedReviewListView extends StatefulWidget {
  final int productId;
  final dynamic fetchReviews;
  final bool showPadding;
  final ListPreferences listPreferences;

  const PaginatedReviewListView({
    Key key,
    this.fetchReviews,
    this.productId,
    this.listPreferences,
    this.showPadding = false,
  }) : super(key: key);

  @override
  _PaginatedReviewListViewState createState() =>
      _PaginatedReviewListViewState();
}

class _PaginatedReviewListViewState extends State<PaginatedReviewListView>
    with AfterLayoutMixin {
  ReviewModel _reviewModel;
  final _pagingController = PagingController<int, Review>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _reviewModel = Provider.of<ReviewModel>(context, listen: false);
    _reviewModel.clearPaginationHistory();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void didUpdateWidget(PaginatedReviewListView oldWidget) {
    if (oldWidget.listPreferences != widget.listPreferences) {
      _pagingController.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    print('fetching new page..');
    if (_pagingController.nextPageKey != null) {
      try {
        final newPage = await _reviewModel.getProductReviews(widget.productId,
            listPreferences: widget.listPreferences);
        if (newPage != null) {
          final isLastPage = newPage.itemList.isEmpty ||
              newPage.itemList.length < 10 ||
              newPage.isLastPage(_pagingController?.itemList?.length ?? 0);

          if (isLastPage) {
            print('last page');
            _pagingController.appendLastPage(newPage.itemList);
          } else {
            print('added new page');
            final nextPageKey = pageKey + 1;
            _pagingController.appendPage(newPage.itemList, nextPageKey);
          }
        } else {
          print('new page is null');
        }
      } catch (error) {
        print(error);
        _pagingController.error = error;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scrollbar(
      thickness: kScrollbarThickness,
      child: PagedListView.separated(
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<Review>(
            itemBuilder: (context, review, i) {
              return ReviewCard(
                  context: context,
                  showDivider: i != _pagingController.itemList.length - 1,
                  review: review);
            },
            firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                  error: _pagingController.error,
                  onTryAgain: () => _pagingController.refresh(),
                ),
            noItemsFoundIndicatorBuilder: (context) => Column(
                  children: [
                    Container(height: 41),
                    Center(
                      child: Text(
                        'không tìm thấy sản phẩm',
                        style:
                            textTheme.bodyText2.copyWith(color: kTertiaryGray),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
            noMoreItemsIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 40),
                  child: SvgPicture.asset(
                    'assets/icons/heart-ballon.svg',
                    width: 30,
                    height: 42,
                  ),
                ),
            firstPageProgressIndicatorBuilder: (context) => Container(
                width: screenSize.width,
                height: screenSize.height / 3,
                child: Center(child: kIndicator())),
            newPageProgressIndicatorBuilder: (context) => Container(
                width: screenSize.width,
                height: screenSize.height / 10,
                child: Center(child: kIndicator()))),
        pagingController: _pagingController,
        padding: widget.showPadding
            ? const EdgeInsets.symmetric(horizontal: 16)
            : EdgeInsets.zero,
        separatorBuilder: (context, index) => const SizedBox(
          height: 0,
        ),
      ),
    );
  }
}
