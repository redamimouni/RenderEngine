//
//  ViewController.swift
//  3DRender
//
//  Created by Reda Mimouni on 19/04/2017.
//
//

import UIKit
import NinevehGL

class ViewController: UIViewController, NGLViewDelegate{
  
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
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    mesh = NGLMesh(file: "back_flip_to_uppercut.dae", settings: [kNGLMeshCentralizeYes: kNGLMeshKeyCentralize, "0.3": kNGLMeshKeyNormalize], delegate: nil)
    camera.add(mesh)
    camera.autoAdjustAspectRatio(true, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

