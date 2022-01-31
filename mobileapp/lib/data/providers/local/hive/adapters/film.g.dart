// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../models/film.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilmAdapter extends TypeAdapter<Film> {
  @override
  final typeId = 0;

  @override
  Film read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Film(
      adult: fields[0] as bool?,
      backdropPath: fields[1] as String?,
      genreIds: (fields[3] as List?)?.cast<int>(),
      id: fields[4] as int?,
      originalLanguage: fields[5] as String?,
      originalTitle: fields[6] as String?,
      overview: fields[7] as String?,
      popularity: fields[8] as num?,
      posterPath: fields[9] as String?,
      releaseDate: fields[10] as String?,
      title: fields[11] as String?,
      video: fields[12] as bool?,
      voteAverage: fields[13] as num?,
      voteCount: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Film obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.backdropPath)
      ..writeByte(3)
      ..write(obj.genreIds)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.originalLanguage)
      ..writeByte(6)
      ..write(obj.originalTitle)
      ..writeByte(7)
      ..write(obj.overview)
      ..writeByte(8)
      ..write(obj.popularity)
      ..writeByte(9)
      ..write(obj.posterPath)
      ..writeByte(10)
      ..write(obj.releaseDate)
      ..writeByte(11)
      ..write(obj.title)
      ..writeByte(12)
      ..write(obj.video)
      ..writeByte(13)
      ..write(obj.voteAverage)
      ..writeByte(14)
      ..write(obj.voteCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
