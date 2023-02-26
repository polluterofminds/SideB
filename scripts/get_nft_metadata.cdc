import BSide from 0x3f99d68674bc7afa
import SideBMetadata from 0x3f99d68674bc7afa

/// This script gets all the view-based metadata associated with the specified NFT
/// and returns it as a single struct

pub struct NFT {
    pub let name: String
    pub let title: String
    pub let artist: String
    pub let description: String
    pub let date: String
    pub let thumbnail: String
    pub let owner: Address
    pub let type: String
    pub let externalURL: String
    pub let serialNumber: UInt64
    pub let collectionPublicPath: PublicPath
    pub let collectionStoragePath: StoragePath
    pub let collectionProviderPath: PrivatePath
    pub let collectionPublic: String
    pub let collectionPublicLinkedType: String
    pub let collectionProviderLinkedType: String
    pub let collectionName: String
    pub let collectionDescription: String
    pub let collectionExternalURL: String
    pub let collectionSquareImage: String
    pub let collectionBannerImage: String
    pub let collectionSocials: {String: String}
    pub let edition: SideBMetadata.Edition
    pub let traits: SideBMetadata.Traits
		pub let medias: SideBMetadata.Medias?
		pub let license: SideBMetadata.License?

    init(
        name: String,
        title: String, 
        artist: String,
        description: String,
        date: String,
        thumbnail: String,
        owner: Address,
        nftType: String,        
        externalURL: String,
        serialNumber: UInt64,
        collectionPublicPath: PublicPath,
        collectionStoragePath: StoragePath,
        collectionProviderPath: PrivatePath,
        collectionPublic: String,
        collectionPublicLinkedType: String,
        collectionProviderLinkedType: String,
        collectionName: String,
        collectionDescription: String,
        collectionExternalURL: String,
        collectionSquareImage: String,
        collectionBannerImage: String,
        collectionSocials: {String: String},
        edition: SideBMetadata.Edition,
        traits: SideBMetadata.Traits,
				medias:SideBMetadata.Medias?,
				license:SideBMetadata.License?
    ) {
        self.name = name
        self.title = title
        self.artist = artist
        self.description = description
        self.date = date
        self.thumbnail = thumbnail
        self.owner = owner
        self.type = nftType        
        self.externalURL = externalURL
        self.serialNumber = serialNumber
        self.collectionPublicPath = collectionPublicPath
        self.collectionStoragePath = collectionStoragePath
        self.collectionProviderPath = collectionProviderPath
        self.collectionPublic = collectionPublic
        self.collectionPublicLinkedType = collectionPublicLinkedType
        self.collectionProviderLinkedType = collectionProviderLinkedType
        self.collectionName = collectionName
        self.collectionDescription = collectionDescription
        self.collectionExternalURL = collectionExternalURL
        self.collectionSquareImage = collectionSquareImage
        self.collectionBannerImage = collectionBannerImage
        self.collectionSocials = collectionSocials
        self.edition = edition
        self.traits = traits
				self.medias=medias
				self.license=license
    }
}

pub fun main(address: Address, id: UInt64): NFT {
    let account = getAccount(address)

    let collection = account
        .getCapability(BSide.CollectionPublicPath)
        .borrow<&{BSide.BSideCollectionPublic}>()
        ?? panic("Could not borrow a reference to the collection")

    let nft = collection.borrowBSide(id: id)!

    // Get the basic display information for this NFT
    let display = SideBMetadata.getDisplay(nft)!

    // Get the royalty information for the given NFT
    // let royaltyView = SideBMetadata.getRoyalties(nft)!

    let externalURL = SideBMetadata.getExternalURL(nft)!

    let collectionDisplay = SideBMetadata.getNFTCollectionDisplay(nft)!
    let nftCollectionView = SideBMetadata.getNFTCollectionData(nft)!

    let nftEditionView = SideBMetadata.getEditions(nft)!
    let serialNumberView = SideBMetadata.getSerial(nft)!
    
    let owner: Address = nft.owner!.address!
    let nftType = nft.getType()

    let collectionSocials: {String: String} = {}
    for key in collectionDisplay.socials.keys {
        collectionSocials[key] = collectionDisplay.socials[key]!.url
    }

		let traits = SideBMetadata.getTraits(nft)!

		let medias=SideBMetadata.getMedias(nft)
		let license=SideBMetadata.getLicense(nft)

    return NFT(
        name: display.name,
        title: display.title,
        artist: display.artist,
        description: display.description,
        date: display.date,
        thumbnail: display.thumbnail.uri(),
        owner: owner,
        nftType: nftType.identifier,        
        externalURL: externalURL.url,
        serialNumber: serialNumberView.number,
        collectionPublicPath: nftCollectionView.publicPath,
        collectionStoragePath: nftCollectionView.storagePath,
        collectionProviderPath: nftCollectionView.providerPath,
        collectionPublic: nftCollectionView.publicCollection.identifier,
        collectionPublicLinkedType: nftCollectionView.publicLinkedType.identifier,
        collectionProviderLinkedType: nftCollectionView.providerLinkedType.identifier,
        collectionName: collectionDisplay.name,
        collectionDescription: collectionDisplay.description,
        collectionExternalURL: collectionDisplay.externalURL.url,
        collectionSquareImage: collectionDisplay.squareImage.file.uri(),
        collectionBannerImage: collectionDisplay.bannerImage.file.uri(),
        collectionSocials: collectionSocials,
        edition: nftEditionView.infoList[0],
        traits: traits,
				medias:medias,
				license:license
    )
}
