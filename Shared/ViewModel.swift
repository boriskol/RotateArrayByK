//
//  ViewModel.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//
/*
 
 */
import Foundation
/*
 
 if A.count > 0 {
   let roundedK: Int = K % A.count
   let rotatedArray = Array(A.dropFirst(A.count - roundedK) + A.dropLast(roundedK))
   return rotatedArray
 }
 return []
 
 */
class ViewModel: ObservableObject {
   
   @Published var gifs = [GifCollectionViewCellViewModel]()
   // MARK:  Initializer Dependency injestion
   let appiCall: ApiLoader?
   
   init(appiCall: ApiLoader = ApiLoader()){
      self.appiCall = appiCall
   }
   
   func rotateByK<T>(with array: [T], k: Int) -> [T] {
      if array.count > 0 {
         let roundedK: Int = k % array.count
         let rotatedArray = Array(array.dropFirst(array.count - roundedK) + array.dropLast(roundedK))
         return rotatedArray
      }
      return []
   }
   
   public func rotateBy(k: Int){
      self.gifs = rotateByK(with: gifs, k: k)
   }
   
   
   @MainActor func loadGift() async {
      Task(priority: .userInitiated, operation: {
         let fp: APIListResponse? = try? await appiCall?.fetchAPI(urlParams: [Constants.rating: Constants.rating, Constants.limit: Constants.limitNum], gifacces: Constants.trending)
         let d = fp?.data.map({ return GifCollectionViewCellViewModel(id: $0.id!, title: $0.title!, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
         })
         self.gifs = d!
      })
   }
   
   
   deinit{
      debugPrint("ViewModel deinit")
   }
}


