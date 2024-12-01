import SwiftUI
import RoomPlan
import RealityKit
import QuickLook
import SceneKit

struct RoomTestView: View {
    @State private var isScanning = false
    @State private var roomCaptureUIView: RoomCaptureUIView? = nil
    @State private var detectedObjects: [CapturedRoom.Object] = []
    @State private var showModelingButton = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), 
                          startPoint: .topLeading, 
                          endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Room Scanner")
                    .font(.system(size: 32, weight: .bold))
                    .padding()
                
                RoomCaptureViewRepresentable(
                    roomCaptureUIView: $roomCaptureUIView,
                    detectedObjects: $detectedObjects
                )
                .frame(maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    if !isScanning {
                        Button(action: {
                            isScanning = true
                            roomCaptureUIView?.startScanning()
                            showModelingButton = false
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Start Scanning")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    } else {
                        Button(action: {
                            isScanning = false
                            roomCaptureUIView?.stopScanning()
                            showModelingButton = true
                        }) {
                            HStack {
                                Image(systemName: "stop.fill")
                                Text("Finish Scanning")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                    
                    if showModelingButton {
                        Button(action: {
                            Task {
                                await roomCaptureUIView?.processScannedData()
                            }
                        }) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                Text("Process Scan")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom)
            }
        }
    }
}

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
    private var exportURL: URL?

    
    // Use ModelCatalog to manage models without ModelProvider protocol
    
    
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
        session.run(configuration: configuration)
        print("Started scanning")
    }
    
    func stopScanning() {
        captureSession?.stop()
        print("Stopped scanning")
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
            // Get the bundle URL for RoomPlanCatalog.bundle
            guard let catalogBundle = Bundle.main.url(forResource: "RoomPlanCatalog",
                                                      withExtension: "bundle") else {
                print("Could not find RoomPlanCatalog.bundle")
                return
            }
            
            // Load the model provider from the catalog bundle
            let modelProvider = try RoomPlanCatalog.load(at: catalogBundle)
            
            
            
            let roomBuilder = RoomBuilder(options: [.beautifyObjects])
            
            // Process the room
            let processedRoom = try await roomBuilder.capturedRoom(from: data)
            
            
            
            // Export USDZ file
            let filename = "Room.usdz"
            let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
            
            
            try processedRoom.export(to: destinationURL, modelProvider: modelProvider, exportOptions: .model)
            
            
            print("USDZ file exported to: \(destinationURL)")
            
            self.exportURL = destinationURL
            
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
        previewController.delegate = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(previewController, animated: true)
        }
    }

    
}




extension RoomCaptureUIView: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return exportURL != nil ? 1 : 0
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let url = exportURL else {
            fatalError("No export URL available")
        }
        return url as QLPreviewItem
    }
    
}

extension RoomCaptureUIView: QLPreviewControllerDelegate {
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        print("Preview dismissed")
    }
    
    func previewController(_ controller: QLPreviewController,
                          shouldOpen url: URL,
                          for item: QLPreviewItem) -> Bool {
        return true
    }
}


