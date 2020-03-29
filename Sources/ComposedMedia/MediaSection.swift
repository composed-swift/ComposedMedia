import Photos
import Composed

open class MediaSection<Element>: NSObject, Section, PHPhotoLibraryChangeObserver where Element: PHObject {

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    private var fetchResult: PHFetchResult<Element>
    public var updateDelegate: SectionUpdateDelegate?

    public var numberOfElements: Int {
        return fetchResult.count
    }

    public init(fetchResult: PHFetchResult<Element>) {
        self.fetchResult = fetchResult
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    public func replace(fetchResult: PHFetchResult<Element>) {
        self.fetchResult = fetchResult
        updateDelegate?.sectionDidReload(self)
    }

    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            guard let details = changeInstance.changeDetails(for: self.fetchResult) else { return }
            fetchResult = details.fetchResultAfterChanges

            guard details.hasIncrementalChanges else {
                updateDelegate?.sectionDidReload(self)
                return
            }

            updateDelegate?.sectionWillUpdate(self)

            details.removedIndexes?.forEach {
                updateDelegate?.section(self, didRemoveElementAt: $0)
            }

            details.insertedIndexes?.forEach {
                updateDelegate?.section(self, didInsertElementAt: $0)
            }

            details.changedIndexes?.forEach {
                updateDelegate?.section(self, didUpdateElementAt: $0)
            }

            details.enumerateMoves { [weak self] from, to in
                guard let self = self else { return }
                self.updateDelegate?.section(self, didMoveElementAt: from, to: to)
            }

            updateDelegate?.sectionDidUpdate(self)
        }
    }

    public func element(at index: Int) -> Element {
        return fetchResult.object(at: index)
    }

    open override var description: String {
        return super.description + " | " + String(describing: fetchResult)
    }

}

extension MediaSection: RandomAccessCollection, BidirectionalCollection {

    public typealias Index = Array<Element>.Index

    public var isEmpty: Bool { return fetchResult.count == 0 }
    public var startIndex: Index { return 0 }
    public var endIndex: Index { return fetchResult.count }

    public subscript(position: Index) -> Element {
        return fetchResult.object(at: position)
    }

}
