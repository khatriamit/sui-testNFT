module nft_tutorial::test_nft{
  use sui::url::{Self,Url};
  use std::string;
  use sui::object::{Self, UID,ID};
  use sui::event;
  use sui::transfer;
  use sui::tx_context::{Self, TxContext};

  struct TestNFT has key, store{
    id:UID,
    name:string::String,
    description:string::String,
    url:Url
  }
  
  struct MintTestNFTEvent has copy, drop{
    object_id:ID,
    creator: address,
    name:string::String,
  }

  public entry fun mint(name:vector<u8>, description:vector<u8>, url:vector<u8>, ctx: &mut TxContext){
    let nft = TestNFT{
      id: object::new(ctx),
      name: string::utf8(name),
      description: string::utf8(description),
      url: url::new_unsafe_from_bytes(url)
    };
    let sender = tx_context::sender(ctx);
    event::emit(MintTestNFTEvent{
      object_id: object::uid_to_inner(&nft.id),
      creator: sender,
      name: nft.name,
    });
    transfer::public_transfer(nft, sender);
  }

  /// update NFT's `description`
  public entry fun update_description(nft: &mut TestNFT, new_description:vector<u8>){
    nft.description = string::utf8(new_description)
  }

  /// Burn NFT
  public entry fun burn(nft:TestNFT){
    let TestNFT{id, name:_, description:_, url:_}=nft;
    object::delete(id)
  }

  /// Get the NFT's `name`
  public fun name(nft: &TestNFT): &string::String {
      &nft.name
  }

  /// Get the NFT's `description`
  public fun description(nft: &TestNFT): &string::String {
      &nft.description
  }

  /// Get the NFT's `url`
  public fun url(nft: &TestNFT): &Url {
      &nft.url
  }
}