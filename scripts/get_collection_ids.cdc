import NonFungibleToken from 0x3f99d68674bc7afa
import BSide from 0x3f99d68674bc7afa

/// Script to get NFT IDs in an account's collection
///
pub fun main(): [UInt64] {
    let account = getAccount(0xcaabaae74fe39fd2)

    let collectionRef = account
        .getCapability(BSide.CollectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection at specified path")

    return collectionRef.getIDs()
}
