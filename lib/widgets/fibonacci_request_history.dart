import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/fibonacci_request.dart';
import '../services/fibonacci_service.dart';

/// Widget creates a scroll window that automatically retrieves new
/// [FibonacciRequest]s and displays them.
class FibonacciRequestHistory extends StatefulWidget {
  const FibonacciRequestHistory(
      {Key? key,
      required this.fibonacciService,
      required this.historyStartDateTime,
      this.pageSize = 5})
      : super(key: key);

  final FibonacciService fibonacciService;
  final int pageSize;
  final DateTime historyStartDateTime;

  @override
  State<FibonacciRequestHistory> createState() =>
      _FibonacciRequestHistoryState();
}

class _FibonacciRequestHistoryState extends State<FibonacciRequestHistory> {
  late DateTime _lastRefresh;
  final PagingController<int?, FibonacciRequest> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _refreshData();
  }

  Future<void> _refreshData() async {
    // Remember the time of the last refresh.
    _lastRefresh = widget.historyStartDateTime;
    _pagingController.refresh();
  }

  Future<void> _fetchPage(int? pageKey) async {
    try {
      // fetch new page from history.
      final fetched = await widget.fibonacciService
          .getHistoryPage(widget.pageSize, pageKey);

      if (fetched.length < widget.pageSize) {
        _pagingController.appendLastPage(fetched);
      } else {
        // the api uses the last retrieved id as key for the next retrieve.
        _pagingController.appendPage(fetched, fetched.last.id);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This indicates the passed DateTime is newer, and a refresh is in order.
    if (widget.historyStartDateTime.isAfter(_lastRefresh)) {
      _refreshData();
    }
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Date'),
              Text('Number'),
              Text('Result'),
            ],
          ),
          Expanded(
            //Use a ScrollConfiguration to make 'Pull-Up' to refresh work on
            //mouse devices.
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
              ),
              child: PagedListView<int?, FibonacciRequest>.separated(
                pagingController: _pagingController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                builderDelegate: PagedChildBuilderDelegate<FibonacciRequest>(
                  itemBuilder: (context, item, index) => Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(item.time.toString()),
                        Text(item.number.toString()),
                        //Limit the (possibly huge) Fibonacci result's height.
                        SizedBox(
                          width: 200.0,
                          height: 100.0,
                          //Do make sure result is scrollable.
                          child: SingleChildScrollView(
                            child: Text(item.result),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
