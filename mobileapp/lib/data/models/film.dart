import 'package:hive/hive.dart';

part '../providers/local/hive/adapters/film.g.dart';

@HiveType(typeId: 0)
class Film {
  @HiveField(0)
  bool? adult;
  @HiveField(1)
  String? backdropPath;
  @HiveField(3)
  List<int>? genreIds;
  @HiveField(4)
  int? id;
  @HiveField(5)
  String? originalLanguage;
  @HiveField(6)
  String? originalTitle;
  @HiveField(7)
  String? overview;
  @HiveField(8)
  num? popularity;
  @HiveField(9)
  String? posterPath;
  @HiveField(10)
  String? releaseDate;
  @HiveField(11)
  String? title;
  @HiveField(12)
  bool? video;
  @HiveField(13)
  num? voteAverage;
  @HiveField(14)
  int? voteCount;

  Film(
      {this.adult,
        this.backdropPath,
        this.genreIds,
        this.id,
        this.originalLanguage,
        this.originalTitle,
        this.overview,
        this.popularity,
        this.posterPath,
        this.releaseDate,
        this.title,
        this.video,
        this.voteAverage,
        this.voteCount});

  Film.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids']?.cast<int>();
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'] != null ? json['title'] : json['name'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['genre_ids'] = this.genreIds;
    data['id'] = this.id;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['overview'] = this.overview;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['release_date'] = this.releaseDate;
    data['title'] = this.title;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    return data;
  }
}