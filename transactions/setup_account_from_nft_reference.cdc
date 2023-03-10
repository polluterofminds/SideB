import NonFungibleToken from 0xf8d6e0586b0a20c7
import MetadataViews from 0xf8d6e0586b0a20c7
import BSide from 0xf8d6e0586b0a20c7

/// This transaction is what an account would run
/// to set itself up to receive NFTs. This function
/// uses views to know where to set up the collection
/// in storage and to create the empty collection.

transaction(address: Address, publicPath: PublicPath, id: UInt64) {

    prepare(signer: AuthAccount) {
        let collection = getAccount(address)
            .getCapability(publicPath)
            .borrow<&{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>()
            ?? panic("Could not borrow a reference to the collection")

        let resolver = collection.borrowViewResolver(id: id)!
        let nftCollectionView = resolver.resolveView(Type<MetadataViews.NFTCollectionData>())! as! MetadataViews.NFTCollectionData

        // Create a new empty collections
        let emptyCollection <- nftCollectionView.createEmptyCollection()

        // save it to the account
        signer.save(<-emptyCollection, to: nftCollectionView.storagePath)

        // create a public capability for the collection
        signer.link<&{NonFungibleToken.CollectionPublic, BSide.BSideCollectionPublic, MetadataViews.ResolverCollection}>(
            nftCollectionView.publicPath,
            target: nftCollectionView.storagePath
        )
    }
}
