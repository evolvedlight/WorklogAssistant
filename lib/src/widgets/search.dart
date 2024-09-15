import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:worklog_assistant/src/providers/search_text_provider.dart';

class SearchWidget extends HookConsumerWidget {
  final FocusNode searchFocusNode;

  SearchWidget(this.searchFocusNode);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.read(searchTextProvider);

    final searchTextController = useListenable(useTextEditingController(text: search));

    searchTextController.addListener(() => ref.read(searchTextProvider.notifier).state = searchTextController.text);
    return TextBox(placeholder: 'Search', controller: searchTextController, focusNode: searchFocusNode);
  }
}
