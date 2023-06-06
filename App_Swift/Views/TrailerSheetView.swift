import SwiftUI

struct TrailerSheetView: View {
    let movie: MovieDto?
    let trailer: VideoDto?
    @Binding var sheetSize: PresentationDetent
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "\(backdropImagesUrlPrefix)\(movie?.backdrop_path ?? "")")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(5)
                        .clipped()
                        .frame(width: 450, height: 500)
                        .overlay(
                            Rectangle()
                                .fill(Color.black.opacity(0.6))
                        )
                } else if phase.error != nil {
                    Text("Image invalid")
                        .bold()
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                } else {
                    ProgressView()
                        .font(.largeTitle)
                }
            }
            VStack(alignment: .leading) {
                if let trailer = trailer {
                    VideoPlayerView(videoId: trailer.key).frame(width: 375 ,height: 300)
                }
            }.clipped()
        }
    }
}
