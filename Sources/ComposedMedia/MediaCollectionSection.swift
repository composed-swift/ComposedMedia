import Photos
import Composed

open class MediaCollectionSection<Element>: Section where Element: PHCollection {

    public var numberOfElements: Int = 0
    public var updateDelegate: SectionUpdateDelegate?

}
