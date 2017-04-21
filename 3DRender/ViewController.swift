//
//  ViewController.swift
//  3DRender
//
//  Created by Reda Mimouni on 19/04/2017.
//
//

import UIKit
import NinevehGL

class ViewController: UIViewController, NGLViewDelegate, NGLMeshDelegate{
  
  var mesh = NGLMesh()
  var camera = NGLCamera()
  
  /*!
   *					Method called at each render cycle.
   *
   *					Place all your drawing commands inside this method. NinevehGL drawing is done by using
   *					cameras. For each camera you want to draw, call its <code>#drawView#</code> method.
   *					Each camera called inside this method will produce its resulting image into the
   *					correspondent NGLView.
   */
  func drawView() {
    mesh.rotateY += 2
    camera.draw()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let view = self.view as! NGLView
    view.delegate = self
    mesh = NGLMesh(file: "untitled.obj", settings: [kNGLMeshKeyOriginal: kNGLMeshOriginalYes,
                                                    kNGLMeshKeyCentralize: kNGLMeshCentralizeYes,
                                                    kNGLMeshKeyNormalize: 0.8], delegate: self)
    mesh.material = NGLMaterial.materialEmerald() as! NGLMaterialProtocol
    camera.add(mesh)
    camera.autoAdjustAspectRatio(true, animated: true)
    NGLDebug.debugMonitor().start(with: self.view as! NGLView!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

