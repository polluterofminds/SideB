import NonFungibleToken from 0x3f99d68674bc7afa
import MetadataViews from 0x3f99d68674bc7afa
import BSide from 0x3f99d68674bc7afa

/// This transaction is what an account would run
/// to set itself up to receive NFTs

transaction {

    prepare(signer: AuthAccount) {
        // Return early if the account already has a collection
        if signer.borrow<&BSide.Collection>(from: BSide.CollectionStoragePath) != nil {
            return
        }

        // Create a new empty collection
        let collection <- BSide.createEmptyCollection()

        // save it to the account
        signer.save(<-collection, to: BSide.CollectionStoragePath)

        // create a public capability for the collection
        signer.link<&{NonFungibleToken.CollectionPublic, BSide.BSideCollectionPublic, MetadataViews.ResolverCollection}>(
            BSide.CollectionPublicPath,
            target: BSide.CollectionStoragePath
        )
    }
}
 