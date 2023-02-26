import NonFungibleToken from 0x3f99d68674bc7afa
import BSide from 0x3f99d68674bc7afa
import MetadataViews from 0x3f99d68674bc7afa
import FungibleToken from 0x3f99d68674bc7afa

/// This script uses the NFTMinter resource to mint a new NFT
/// It must be run with the account that has the minter resource
/// stored in /storage/NFTMinter

transaction(
    recipient: Address,
    name: String,
    title: String, 
    artist: String, 
    description: String,
    date: String,
    thumbnail: String,
) {

    /// local variable for storing the minter reference
    let minter: &BSide.NFTMinter

    /// Reference to the receiver's collection
    let recipientCollectionRef: &{NonFungibleToken.CollectionPublic}

    /// Previous NFT ID before the transaction executes
    let mintingIDBefore: UInt64

    prepare(signer: AuthAccount) {
        self.mintingIDBefore = BSide.totalSupply

        // borrow a reference to the NFTMinter resource in storage
        self.minter = signer.borrow<&BSide.NFTMinter>(from: BSide.MinterStoragePath)
            ?? panic("Account does not store an object at the specified path")

        // Borrow the recipient's public NFT collection reference
        self.recipientCollectionRef = getAccount(recipient)
            .getCapability(BSide.CollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")
    }

    execute {
        



        // Mint the NFT and deposit it to the recipient's collection
        self.minter.mintNFT(
            recipient: self.recipientCollectionRef,
            name: name,
            title: title, 
            artist: artist,            
            date: date,
            description: description,
            thumbnail: thumbnail      
        )
    }

    post {
        self.recipientCollectionRef.getIDs().contains(self.mintingIDBefore): "The next NFT ID should have been minted and delivered"
        BSide.totalSupply == self.mintingIDBefore + 1: "The total supply should have been increased by 1"
    }
}
 