//
//  MapView.swift
//  nasa-ios-app
//
//  Created by Aluno ISTEC on 07/06/2023.
//
import MapKit
import SwiftUI

struct MapView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    var body: some View {
        Map(coordinateRegion: $mapRegion)
                    .gesture(TapGesture().onEnded { tap in
                        let coordinate = mapRegion.convert(tap.location, toCoordinateFrom: nil)
                        selectedCoordinate = coordinate
                        print("Selected coordinate: \(coordinate)")
                    })
                    .overlay(
                        Group {
                            if let mapOverlayPosition = getMapOverlayPosition() {
                                Circle()
                                    .fill(Color.blue)
                                    .opacity(0.4)
                                    .frame(width: 10, height: 10)
                                    .position(mapOverlayPosition)
                            }
                        }
                    )
            }

            func getMapOverlayPosition() -> CGPoint? {
                if let coordinate = selectedCoordinate {
                    return mapRegion.convert(coordinate, toPointTo: nil)
                }
                return nil
            }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
