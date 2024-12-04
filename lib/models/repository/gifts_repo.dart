import '../data/Gifts.dart';

abstract class gifts_repo {
  getGifts(Gift myGift);
  deleteGift(Gift myGift);
  editGift(Gift myGift);
  createGift(Gift myGift);
}
