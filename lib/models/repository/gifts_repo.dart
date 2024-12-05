import '../data/Gifts.dart';
import '../data/users.dart';

abstract class gifts_repo {
  getGifts(User myUser);
  deleteGift(Gift myGift);
  editGift(Gift myGift);
  createGift(Gift myGift);
}
