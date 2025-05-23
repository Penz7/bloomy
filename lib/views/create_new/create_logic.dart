import 'package:bloomy/models/song_model.dart';
import 'package:bloomy/services/album_service.dart';
import 'package:bloomy/services/song_service.dart';
import 'package:get/get.dart';

class CreateLogic extends GetxController {
  final AlbumService _albumService = AlbumService();
  var selectedIds = <String>{}.obs;
  final _songService = Get.find<SongService>();


  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is RxSet<String>) {
      selectedIds.value = Set<String>.from(Get.arguments);
      print(selectedIds);
    } else {
      selectedIds.clear(); // hoặc selectedIds.value = {};
    }
  }

  void createNewAlbum(String name) async {
    // Lấy random 1 cover image
    final List<String> imageAssets = List.generate(
      100,
          (index) => 'assets/images/img${index + 1}.jpg',
    );
    imageAssets.shuffle(); // random

    final songs = await convertIdsToSongs(selectedIds.toList());

    await _albumService.addAlbum(name, imageAssets.first, songs);
  }

  Future<List<SongModel>> convertIdsToSongs(List<String> ids) async {
    final allSongs = await _songService.getSavedSongs(); // lấy tất cả bài hát từ local/file/...
    return allSongs.where((song) => ids.contains(song.id)).toList();
  }
}