class Post {
   String title;
   String description;

  Post({this.title, this.description});

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      title: map['title'],
      description: map['description']
    );
  }

  static Map<String, dynamic> toMap(Post post) {
    final Map<String, dynamic> data = <String, dynamic> {
      'title': post.title,
      'description': post.description
    };

    return data;
  }
}