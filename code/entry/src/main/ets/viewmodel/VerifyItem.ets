
export default class VerifyItem {
  /**
   * Image of verify item.
   */
  image: Resource;
  /**
   * Correct characters of verify item.
   */
  characters: string;

  constructor(image: Resource, characters: string) {
    this.image = image;
    this.characters = characters;
  }

  static getVerifyMap(): Map<number, VerifyItem> {
    let verifyMap: Map<number, VerifyItem> = new Map();
    verifyMap.set(0, new VerifyItem($r('app.media.ic_verity_character1'), 'XYZK'));
    verifyMap.set(1, new VerifyItem($r('app.media.ic_verity_character2'), 'LHBR'));
    return verifyMap;
  }
}