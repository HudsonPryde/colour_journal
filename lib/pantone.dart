import 'dart:math';
import 'package:delta_e/delta_e.dart';

class Pantone {
  final Map<String, String> _values = {
    '#CD4A4A': 'Mahogany',
    '#CC6666': 'Fuzzy Wuzzy Brown',
    '#BC5D58': 'Chestnut',
    '#FF5349': 'Red Orange',
    '#FD5E53': 'Sunset Orange',
    '#FD7C6E': 'Bittersweet',
    '#FDBCB4': 'Melon',
    '#FF6E4A': 'Outrageous Orange',
    '#FFA089': 'Vivid Tangerine',
    '#EA7E5D': 'Burnt Sienna',
    '#B4674D': 'Brown',
    '#A5694F': 'Sepia',
    '#FF7538': 'Orange',
    '#FF7F49': 'Burnt Orange',
    '#DD9475': 'Copper',
    '#FF8243': 'Mango Tango',
    '#FFA474': 'Atomic Tangerine',
    '#9F8170': 'Beaver',
    '#CD9575': 'Antique Brass',
    '#EFCDB8': 'Desert Sand',
    '#D68A59': 'Raw Sienna',
    '#DEAA88': 'Tumbleweed',
    '#FAA76C': 'Tan',
    '#FFCFAB': 'Peach',
    '#FFBD88': 'Macaroni and Cheese',
    '#FDD9B5': 'Apricot',
    '#FFA343': 'Neon Carrot',
    '#EFDBC5': 'Almond',
    '#FFB653': 'Yellow Orange',
    '#E7C697': 'Gold',
    '#8A795D': 'Shadow',
    '#FAE7B5': 'Banana Mania',
    '#FFCF48': 'Sunglow',
    '#FCD975': 'Goldenrod',
    '#FDDB6D': 'Dandelion',
    '#FCE883': 'Yellow',
    '#F0E891': 'Green Yellow',
    '#ECEABE': 'Spring Green',
    '#BAB86C': 'Olive Green',
    '#FDFC74': 'Unmellow Yellow',
    '#FFFF99': 'Canary',
    '#C5E384': 'Yellow Green',
    '#B2EC5D': 'Inch Worm',
    '#87A96B': 'Asparagus',
    '#A8E4A0': 'Granny Smith Apple',
    '#1DF914': 'Electric Lime',
    '#76FF7A': 'Screamin Green',
    '#71BC78': 'Fern',
    '#6DAE81': 'Forest Green',
    '#9FE2BF': 'Sea Green',
    '#1CAC78': 'Green',
    '#30BA8F': 'Mountain Meadow',
    '#45CEA2': 'Shamrock',
    '#3BB08F': 'Jungle Green',
    '#1CD3A2': 'Caribbean Green',
    '#17806D': 'Tropical Rain Forest',
    '#158078': 'Pine Green',
    '#1FCECB': 'Robin Egg Blue',
    '#78DBE2': 'Aquamarine',
    '#77DDE7': 'Turquoise Blue',
    '#80DAEB': 'Sky Blue',
    '#414A4C': 'Outer Space',
    '#199EBD': 'Blue Green',
    '#1CA9C9': 'Pacific Blue',
    '#1DACD6': 'Cerulean',
    '#9ACEEB': 'Cornflower',
    '#1A4876': 'Midnight Blue',
    '#1974D2': 'Navy Blue',
    '#2B6CC4': 'Denim',
    '#1F75FE': 'Blue',
    '#C5D0E6': 'Periwinkle',
    '#B0B7C6': 'Cadet Blue',
    '#5D76CB': 'Indigo',
    '#A2ADD0': 'Wild Blue Yonder',
    '#979AAA': 'Manatee',
    '#ADADD6': 'Blue Bell',
    '#7366BD': 'Blue Violet',
    '#7442C8': 'Purple Heart',
    '#7851A9': 'Royal Purple',
    '#9D81BA': 'Purple Mountains’ Majesty',
    '#926EAE': 'Violet (Purple)',
    '#CDA4DE': 'Wisteria',
    '#8F509D': 'Vivid Violet',
    '#C364C5': 'Fuchsia',
    '#FB7EFD': 'Shocking Pink',
    '#FC74FD': 'Pink Flamingo',
    '#8E4585': 'Plum',
    '#FF1DCE': 'Purple Pizzazz',
    '#FF48D0': 'Razzle Dazzle Rose',
    '#E6A8D7': 'Orchid',
    '#C0448F': 'Red Violet',
    '#6E5160': 'Eggplant',
    '#DD4492': 'Cerise',
    '#FF43A4': 'Wild Strawberry',
    '#F664AF': 'Magenta',
    '#FCB4D5': 'Lavender',
    '#FFBCD9': 'Cotton Candy',
    '#F75394': 'Violet Red',
    '#FFAACC': 'Carnation Pink',
    '#E3256B': 'Razzmatazz',
    '#FDD7E4': 'Piggy Pink',
    '#CA3767': 'Jazzberry Jam',
    '#DE5D83': 'Blush',
    '#FC89AC': 'Tickle Me Pink',
    '#F780A1': 'Pink Sherbet',
    '#C8385A': 'Maroon',
    '#EE204D': 'Red',
    '#FF496C': 'Radical Red',
    '#EF98AA': 'Mauvelous',
    '#FC6C85': 'Wild Watermelon',
    '#FC2847': 'Scarlet',
    '#FF9BAA': 'Salmon',
    '#CB4154': 'Brick Red',
    '#EDEDED': 'White',
    '#DBD7D2': 'Timberwolf',
    '#CDC5C2': 'Silver',
    '#95918C': 'Gray',
    '#232323': 'Black'
  };

  String? getColour(String hex) {
    if (_values.containsKey(hex)) {
      return _values[hex];
    }
    int inputColour = int.parse('0x${hex.substring(1)}');
    int r1 = (inputColour >> 16) & 0xff;
    int g1 = (inputColour >> 8) & 0xff;
    int b1 = (inputColour >> 0) & 0xff;
    LabColor l1 = LabColor.fromRGB(r1, g1, b1);
    print('$r1 $g1 $b1');

    // find the colour with the smallest euclidean distance from given hex
    double minDistance = double.infinity;
    String colourHex = '';
    for (var c in _values.keys) {
      int intColour = int.parse('0x${c.substring(1)}');
      int r2 = (intColour >> 16) & 0xff;
      int g2 = (intColour >> 8) & 0xff;
      int b2 = (intColour >> 0) & 0xff;
      LabColor l2 = LabColor.fromRGB(r2, g2, b2);
      double distance =
          deltaE00(l1, l2, const Weights(lightness: 6, chroma: 3, hue: 6));
      if (distance < minDistance) {
        minDistance = distance;
        colourHex = c;
        print('$r2 $g2 $b2 $minDistance');
      }
    }
    return _values[colourHex];
  }
}
