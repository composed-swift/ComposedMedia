import Photos
import Composed

open class MediaAssetSection<Element>: Section where Element: PHAsset {

    public var numberOfElements: Int = 0
    public var updateDelegate: SectionUpdateDelegate?

}
