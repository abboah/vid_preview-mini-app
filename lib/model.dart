class Model {
  String name;
  String price;
  String imageUrl;
  String videoUrl;

  Model({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.videoUrl,
  });

  static List<Model> model = [];

  static void addModel() {
    model = [
      Model(
          name: 'First Item',
          price: '\$300',
          imageUrl: 'assets/1.jpg',
          videoUrl: 'assets/vid1.mp4'),
      Model(
          name: 'Second Item',
          price: '\$200',
          imageUrl: 'assets/2.jpg',
          videoUrl: 'assets/vid2.mp4'),
      Model(
          name: 'Third Item',
          price: '\$350',
          imageUrl: 'assets/3.jpg',
          videoUrl: 'assets/vid3.mp4'),
      Model(
          name: 'Fourth Item',
          price: '\$190',
          imageUrl: 'assets/4.jpg',
          videoUrl: 'assets/vid4.mp4'),
      Model(
          name: 'Fifth Item',
          price: '\$450',
          imageUrl: 'assets/5.jpg',
          videoUrl: 'assets/vid5.mp4'),
    ];
  }
}
