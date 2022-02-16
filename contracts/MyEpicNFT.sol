pragma solidity ^0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.

  string newSvg = "<svg width='325' height='432' fill='none' xmlns='http://www.w3.org/2000/svg'><style>@keyframes hideshow{0%,to{opacity:0}50%{opacity:1}}</style><rect width='325' height='432' rx='35' fill='url(#a)'/><path d='M128.57 163.871h67.858c.792 0 1.584.05 2.37.151a13.98 13.98 0 0 0-5.702-9.401 13.983 13.983 0 0 0-10.734-2.381l-55.806 9.528h-.064a13.988 13.988 0 0 0-8.709 5.541 18.569 18.569 0 0 1 10.787-3.438Z' fill='url(#b)'/><path d='M196.429 168.96h-67.858A13.585 13.585 0 0 0 115 182.532v40.714a13.587 13.587 0 0 0 13.571 13.571h67.858A13.589 13.589 0 0 0 210 223.246v-40.714a13.585 13.585 0 0 0-13.571-13.572Zm-10.073 40.714a6.783 6.783 0 0 1-6.655-8.109 6.787 6.787 0 0 1 13.441 1.324 6.786 6.786 0 0 1-6.786 6.785Z' fill='url(#c)'/><path d='M115.106 196.845v-21.099c0-4.595 2.545-12.299 11.377-13.968 7.496-1.406 14.918-1.406 14.918-1.406s4.877 3.393.848 3.393-3.923 5.195 0 5.195 0 4.983 0 4.983l-15.798 17.919-11.345 4.983Z' fill='url(#d)'/><text fill='#F7F7F7' xml:space='preserve' style='white-space:pre;animation:hideshow 5s ease infinite' font-family='Rubik' font-size='36' font-weight='300' letter-spacing='.05em'><tspan x='123' y='256.83'>CoolBeansGreg</tspan></text><text fill='#F7F7F7' xml:space='preserve' style='white-space:pre' font-family='Rubik' font-size='18' font-weight='300' letter-spacing='.05em'><tspan x='117' y='278.665'>Certificate</tspan></text><defs><linearGradient id='a' x1='162.5' y1='0' x2='167.553' y2='535.205' gradientUnits='userSpaceOnUse'><stop offset='.141'/><stop offset='1' stop-color='#8606EB'/></linearGradient><linearGradient id='b' x1='158.291' y1='152' x2='158.291' y2='167.309' gradientUnits='userSpaceOnUse'><stop offset='.047' stop-color='#8606EB'/><stop offset='1' stop-color='#8606EB' stop-opacity='.16'/></linearGradient><linearGradient id='c' x1='162.5' y1='168.96' x2='162.5' y2='236.817' gradientUnits='userSpaceOnUse'><stop offset='.047' stop-color='#8606EB'/><stop offset='1' stop-color='#8606EB' stop-opacity='.16'/></linearGradient><linearGradient id='d' x1='129.55' y1='160.372' x2='129.55' y2='196.845' gradientUnits='userSpaceOnUse'><stop offset='.047' stop-color='#8606EB'/><stop offset='1' stop-color='#8606EB' stop-opacity='.16'/></linearGradient></defs></svg>";


  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  // string[] firstWords = ["Casey", "Doom", "Paranoid", "Little", "Sonic", "Quick"];
  // string[] secondWords = ["Book", "Slam", "Pizza", "Pam", "Bored", "Papa"];
  // string[] thirdWords = ["Lord", "Baron", "Hammer", "Fest", "Shed", "Manor"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("Magic NFT for Greg", "MGC") {
    console.log("This is my NFT contract. Woah!");
  }


  // function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
  //   uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
  //   rand = rand % firstWords.length;
  //   return firstWords[rand];
  // }

  // function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
  //   uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
  //   rand = rand % secondWords.length;
  //   return secondWords[rand];
  // }

  // function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
  //   uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
  //   rand = rand % thirdWords.length;
  //   return thirdWords[rand];
  // }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    // We go and randomly grab one word from each of the three arrays.
    // string memory first = pickRandomFirstWord(newItemId);
    // string memory second = pickRandomSecondWord(newItemId);
    // string memory third = pickRandomThirdWord(newItemId);

    // string memory combinedWord = string(abi.encodePacked(first, second, third));
    // string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
    
     // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "A magic svg nft", "description": "Super nice.", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(newSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(
        string(
            abi.encodePacked(
                "https://nftpreview.0xdev.codes/?code=",
                finalTokenUri
            )
        )
    );
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
    
  }
}