import SwiftUI
import RoomPlan
import RealityKit
import QuickLook

struct RoomTestView: View {
    @State private var isScanning = false
    @State private var roomCaptureUIView: RoomCaptureUIView? = nil
    @State private var detectedObjects: [CapturedRoom.Object] = []
    @State private var showModelingButton = false
    
    var body: some View {
        VStack {
            Text("Room Scanning")
                .font(.title)
                .padding()
            
            RoomCaptureViewRepresentable(
                roomCaptureUIView: $roomCaptureUIView,
                detectedObjects: $detectedObjects
            )
            .frame(maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .shadow(radius: 5)
            
            HStack(spacing: 20) {
                Button(action: {
                    isScanning = true
                    roomCaptureUIView?.startScanning()
                    showModelingButton = false
                }) {
                    Text("Start Scanning")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isScanning = false
                    roomCaptureUIView?.stopScanning()
                    showModelingButton = true
                }) {
                    Text("Finish Scanning")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            if showModelingButton {
                Button(action: {
                    Task {
                        await roomCaptureUIView?.processScannedData()
                    }
                }) {
                    Text("Process Scan")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}
//struct RoomTestView : View {
//    var body: some View {
//        VStack {
//            Text("Room Scanning")
//                .font(.title)
//                .padding()
//            
//            // Debug button to check bundle contents
//            Button(action: {
//                // Check if bundle exists
//                // Check if bundle exists
//                if let bundlePath = Bundle.main.path(forResource: "Models", ofType: "bundle"),
//                   let modelsBundle = Bundle(path: bundlePath) {
//                    print("Models bundle found at: \(bundlePath)")
//                    
//                    do {
//                        let categoryName = "chair"
//                        // Use the Models bundle instead of main bundle
//                        guard let modelURL = modelsBundle.url(forResource: categoryName,
//                                                            withExtension: "usdc",
//                                                            subdirectory: "Resources/\(categoryName)") else {
//                            print("No model found for category: \(categoryName) at path: Resources/\(categoryName)/\(categoryName).usdc")
//                            
//                            // Debug: Print the full attempted path
//                            let attemptedPath = "\(bundlePath)/Resources/\(categoryName)/\(categoryName).usdc"
//                            print("Attempted full path: \(attemptedPath)")
//                            return
//                        }
//                        
//                        print("Model URL found: \(modelURL)")
//                        
//                        // List all contents recursively
//                        let fileManager = FileManager.default
//                        let items = try fileManager.contentsOfDirectory(atPath: bundlePath)
//                        
//                        print("\nBundle contents:")
//                        for item in items {
//                            print("- \(item)")
//                            
//                            // If it's a directory, list its contents
//                            let itemPath = (bundlePath as NSString).appendingPathComponent(item)
//                            if let subItems = try? fileManager.contentsOfDirectory(atPath: itemPath) {
//                                for subItem in subItems {
//                                    print("  └─ \(subItem)")
//                                    
//                                    // Check for category folders
//                                    let subItemPath = (itemPath as NSString).appendingPathComponent(subItem)
//                                    if let categoryItems = try? fileManager.contentsOfDirectory(atPath: subItemPath) {
//                                        for categoryItem in categoryItems {
//                                            print("     └─ \(categoryItem)")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    } catch {
//                        print("Error listing bundle contents: \(error)")
//                    }
//                } else {
//                    print("Models bundle not found!")
//                }
//
//            }){
//                Text("Check Bundle")
//                    .padding()
//                    .background(Color.orange)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//            
//            
//        }
//    }
//
//}

struct RoomCaptureViewRepresentable: UIViewRepresentable {
    @Binding var roomCaptureUIView: RoomCaptureUIView?
    @Binding var detectedObjects: [CapturedRoom.Object]
    
    func makeUIView(context: Context) -> RoomCaptureUIView {
        let view = RoomCaptureUIView(frame: .zero)
        DispatchQueue.main.async {
            self.roomCaptureUIView = view
        }
        return view
    }
    
    func updateUIView(_ uiView: RoomCaptureUIView, context: Context) {}
}

class RoomCaptureUIView: UIView, RoomCaptureSessionDelegate {
    private var roomCaptureView: RoomCaptureView!
        private var captureSession: RoomCaptureSession?
        private var roomBuilder = RoomBuilder(options: [.beautifyObjects])
        var detectedObjects: [CapturedRoom.Object] = []
        private var capturedRoomData: CapturedRoomData?
        
        // Use ModelCatalog to manage models without ModelProvider protocol
        private var modelCatalog = ModelCatalog()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupRoomCaptureView()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupRoomCaptureView()
        }


    
    
    override func layoutSubviews() {
            super.layoutSubviews()
            roomCaptureView?.frame = bounds // Ensure proper sizing when view layout changes
        }
    
    private func setupRoomCaptureView() {
            roomCaptureView?.removeFromSuperview()
            
            roomCaptureView = RoomCaptureView(frame: bounds)
            roomCaptureView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(roomCaptureView)
            
            NSLayoutConstraint.activate([
                roomCaptureView.topAnchor.constraint(equalTo: topAnchor),
                roomCaptureView.leadingAnchor.constraint(equalTo: leadingAnchor),
                roomCaptureView.trailingAnchor.constraint(equalTo: trailingAnchor),
                roomCaptureView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            captureSession = roomCaptureView.captureSession
            captureSession?.delegate = self
            
            print("RoomCaptureView setup completed")
        }
        
        func startScanning() {
            guard let session = captureSession else {
                print("Error: Capture session not initialized")
                return
            }
            
            let configuration = RoomCaptureSession.Configuration()
            do {
                try session.run(configuration: configuration)
                print("Started scanning")
            } catch {
                print("Failed to start scanning: \(error)")
            }
        }
        
    func stopScanning() {
            captureSession?.stop()
            print("Stopped scanning")
            
            // Switch to AR view after scanning
            DispatchQueue.main.async { [weak self] in
                self?.roomCaptureView.isHidden = true
            }
        }
        
    func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: Error?) {
            if let error = error {
                print("Error capturing room: \(error)")
                return
            }
            self.capturedRoomData = data
            print("Scan completed and data stored")
        }
    
    // Process the scanned data when user requests it
    func processScannedData() async {
        guard let data = capturedRoomData else {
            print("No captured data available")
            return
        }
        
        do {
            // Initialize RoomBuilder with beautifyObjects option
            let roomBuilder = RoomBuilder(options: [.beautifyObjects])
            
            // Process the room
            let processedRoom = try await roomBuilder.capturedRoom(from: data)
            print("Room processed successfully")
            
            DispatchQueue.main.async {
                self.detectedObjects = processedRoom.objects
                print("Detected objects count: \(processedRoom.objects.count)")
                
                // Print detected objects for debugging
                processedRoom.objects.forEach { object in
                    print("""
                        Detected object:
                        - Category: \(object.category)
                        - Position: \(object.transform.columns.3)
                        - Dimensions: \(object.dimensions)
                        """)
                }
            }
            
            // Export USDZ file
            let filename = "Room.usdz"
            let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
            try await processedRoom.export(to: destinationURL)
            print("USDZ file exported to: \(destinationURL)")
            
            // Present the USDZ preview
            DispatchQueue.main.async {
                self.presentQuickLookPreview(at: destinationURL)
            }
            
        } catch {
            print("Error processing room: \(error)")
        }
    }


    
    private func presentQuickLookPreview(at url: URL) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(previewController, animated: true)
        }
    }
}

struct CategoryAttributes: Codable {
    let folderRelativePath: String
    let modelFilename: String?
    let attributes: [String: String]
    let category: String // This should map to CapturedRoom.Object.Category
}

class ModelCatalog {
    private var catalog: [CategoryAttributes]
    
    init() {
        // Load and parse catalog.plist from models.bundle
        guard let bundlePath = Bundle.main.path(forResource: "Models", ofType: "bundle"),
              let modelsBundle = Bundle(path: bundlePath),
              let plistURL = modelsBundle.url(forResource: "catalog", withExtension: "plist"),
              let data = try? Data(contentsOf: plistURL),
              let catalog = try? PropertyListDecoder().decode([CategoryAttributes].self, from: data) else {
            fatalError("Could not load or parse catalog.plist")
        }
        
        self.catalog = catalog
    }
    
    // Function to instantiate a ModelProvider
    func createModelProvider() -> CapturedRoom.ModelProvider {
        let modelProvider = CustomModelProvider()
        
        for categoryAttribute in catalog {
            guard let modelFilename = categoryAttribute.modelFilename else {
                continue // Skip if no modelFilename is provided
            }
            
            let folderRelativePath = categoryAttribute.folderRelativePath
            guard let bundlePath = Bundle.main.path(forResource: "Models", ofType: "bundle"),
                  let modelsBundle = Bundle(path: bundlePath),
                  let modelURL = modelsBundle.url(forResource: modelFilename, withExtension: nil, subdirectory: folderRelativePath) else {
                print("Could not find model file at path \(folderRelativePath)/\(modelFilename)")
                continue
            }
            
            if categoryAttribute.attributes.isEmpty {
                if let capturedCategory = CapturedRoom.Object.Category(rawValue: categoryAttribute.category.lowercased()) {
                    try? modelProvider.setModelFileURL(modelURL, for: capturedCategory)
                }
            } else {
                try? modelProvider.setModelFileURL(modelURL, for: categoryAttribute.attributes)
            }
        }
        
        return modelProvider
    }
}

struct CategoryAttributes: Codable {
    let folderRelativePath: String
    let modelFilename: String?
    let attributes: [String: String] // Assuming attributes are key-value pairs
    let category: String // This should map to CapturedRoom.Object.Category
}

class CustomModelProvider: NSObject, CapturedRoom.ModelProvider {
    
    private var modelURLsByCategory = [CapturedRoom.Object.Category : URL]()
    private var modelURLsByAttributes = [[String : String] : URL]()
    
    // Set URL by category
    func setModelFileURL(_ url: URL, for category: CapturedRoom.Object.Category) throws {
        modelURLsByCategory[category] = url
    }
    
    // Set URL by attributes (key-value pairs)
    func setModelFileURL(_ url: URL, for attributes: [String : String]) throws {
        modelURLsByAttributes[attributes] = url
    }
    
    // Provide the correct URL based on the object's category and dimensions
    func model(for category: CapturedRoom.Object.Category, dimensions: simd_float3) async throws -> URL? {
        if let url = modelURLsByCategory[category] {
            return url
        } else {
            print("No matching model found for category \(category)")
            return nil
        }
    }
}




extension RoomCaptureUIView: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let filename = "Room.usdz"
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        return destinationURL as QLPreviewItem
    }
}
