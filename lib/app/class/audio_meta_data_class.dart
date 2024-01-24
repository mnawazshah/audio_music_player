class AudioMetadataInfoClass {
  String fileName;
  int duration;
  String? title;
  String? artistName;
  String? albumName;
  String? albumArtistName;
  // ImageDataClass albumArt;

  AudioMetadataInfoClass(
    this.fileName,
    this.duration,
    this.title,
    this.artistName,
    this.albumName,
    this.albumArtistName,
  );
}
