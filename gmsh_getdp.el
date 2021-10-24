;; Initial Author: Tobias Nähring at tn-home.de published on Thu Mar 7 09:08:11 CET 2013 to gmsh@geiz.org with Message-id <948703310.104698.1362643691552.open-xchange@email.1und1.de>, Subject: [Gmsh] gmsh.el, as archived in http://onelab.info/pipermail/gmsh/2013/007976.html
;; republished on Oct 5, 2017 with extensions in github.com/Bertbk by Bertrand Thierry
;; revised by Marco Munari from 2021-10-19 based on Gmsh 4.9.0+

(require 'cl)

;; Remove previous associations of file extension .geo with idlwave:
(setq auto-mode-alist (delete-if '(lambda (x) (equal (car x) "\\.geo\\'")) auto-mode-alist))

(defvar gmsh/getdp-functions-list
  '("Tanh" "Tan" "Sinh" "Sin" "Sqrt" "Rand" "Modulo" "Log" "Hypot" "Floor" "Fmod" "Fabs" "Exp" "Cosh" "Cos" "Ceil" "Atan" "Atan2" "Asin" "Acos"
    "Printf" "Print" "Sprintf" "Str" "StrCat" "StrFind")
  "Function identifier common to gmsh and getdp")

(defvar gmsh/getdp-keywords-list
  '("For" "EndFor" "If" "EndIf" "Else" "ElseIf" "Include" "Macro"
    "Choices" "Label" "Path" "Visible" "Highlight"
    "ReadOnly" "ReadOnlyRange" "Color" "Visible")
  "Keyword identifiers common to gmsh and getdp")

(defvar gmsh/getdp-constants-list
  '("Pi" "View" ".Attributes" ".Light" ".NbIso" ".IntervalsType" ".ShowScale" ".LineWidth" ".ColorTable"

    "General.AxesFormatX"
    "General.AxesFormatY"
    "General.AxesFormatZ"
    "General.AxesLabelX"
    "General.AxesLabelY"
    "General.AxesLabelZ"
    "General.BackgroundImageFileName"
    "General.BuildInfo"
    "General.BuildOptions"
    "General.DefaultFileName"
    "General.Display"
    "General.ErrorFileName"
    "General.ExecutableFileName"
    "General.FileName"
    "General.FltkTheme"
    "General.GraphicsFont"
    "General.GraphicsFontEngine"
    "General.GraphicsFontTitle"
    "General.OptionsFileName"
    "General.RecentFile0"
    "General.RecentFile1"
    "General.RecentFile2"
    "General.RecentFile3"
    "General.RecentFile4"
    "General.RecentFile5"
    "General.RecentFile6"
    "General.RecentFile7"
    "General.RecentFile8"
    "General.RecentFile9"
    "General.SessionFileName"
    "General.ScriptingLanguages"
    "General.TextEditor"
    "General.TmpFileName"
    "General.Version"
    "General.WatchFilePattern"
    "General.AbortOnError"
    "General.AlphaBlending"
    "General.Antialiasing"
    "General.ArrowHeadRadius"
    "General.ArrowStemLength"
    "General.ArrowStemRadius"
    "General.Axes"
    "General.AxesMikado"
    "General.AxesAutoPosition"
    "General.AxesForceValue"
    "General.AxesMaxX"
    "General.AxesMaxY"
    "General.AxesMaxZ"
    "General.AxesMinX"
    "General.AxesMinY"
    "General.AxesMinZ"
    "General.AxesTicsX"
    "General.AxesTicsY"
    "General.AxesTicsZ"
    "General.AxesValueMaxX"
    "General.AxesValueMaxY"
    "General.AxesValueMaxZ"
    "General.AxesValueMinX"
    "General.AxesValueMinY"
    "General.AxesValueMinZ"
    "General.BackgroundGradient"
    "General.BackgroundImage3D"
    "General.BackgroundImagePage"
    "General.BackgroundImagePositionX"
    "General.BackgroundImagePositionY"
    "General.BackgroundImageWidth"
    "General.BackgroundImageHeight"
    "General.BoundingBoxSize"
    "General.Camera"
    "General.CameraAperture"
    "General.CameraEyeSeparationRatio"
    "General.CameraFocalLengthRatio"
    "General.Clip0A"
    "General.Clip0B"
    "General.Clip0C"
    "General.Clip0D"
    "General.Clip1A"
    "General.Clip1B"
    "General.Clip1C"
    "General.Clip1D"
    "General.Clip2A"
    "General.Clip2B"
    "General.Clip2C"
    "General.Clip2D"
    "General.Clip3A"
    "General.Clip3B"
    "General.Clip3C"
    "General.Clip3D"
    "General.Clip4A"
    "General.Clip4B"
    "General.Clip4C"
    "General.Clip4D"
    "General.Clip5A"
    "General.Clip5B"
    "General.Clip5C"
    "General.Clip5D"
    "General.ClipFactor"
    "General.ClipOnlyDrawIntersectingVolume"
    "General.ClipOnlyVolume"
    "General.ClipPositionX"
    "General.ClipPositionY"
    "General.ClipWholeElements"
    "General.ColorScheme"
    "General.ConfirmOverwrite"
    "General.ContextPositionX"
    "General.ContextPositionY"
    "General.DetachedMenu"
    "General.DisplayBorderFactor"
    "General.DoubleBuffer"
    "General.DrawBoundingBoxes"
    "General.ExpertMode"
    "General.ExtraPositionX"
    "General.ExtraPositionY"
    "General.ExtraHeight"
    "General.ExtraWidth"
    "General.FastRedraw"
    "General.FieldPositionX"
    "General.FieldPositionY"
    "General.FieldHeight"
    "General.FieldWidth"
    "General.FileChooserPositionX"
    "General.FileChooserPositionY"
    "General.FltkColorScheme"
    "General.FltkRefreshRate"
    "General.FontSize"
    "General.GraphicsFontSize"
    "General.GraphicsFontSizeTitle"
    "General.GraphicsHeight"
    "General.GraphicsPositionX"
    "General.GraphicsPositionY"
    "General.GraphicsWidth"
    "General.HighOrderToolsPositionX"
    "General.HighOrderToolsPositionY"
    "General.HighResolutionGraphics"
    "General.InitialModule"
    "General.InputScrolling"
    "General.Light0"
    "General.Light0X"
    "General.Light0Y"
    "General.Light0Z"
    "General.Light0W"
    "General.Light1"
    "General.Light1X"
    "General.Light1Y"
    "General.Light1Z"
    "General.Light1W"
    "General.Light2"
    "General.Light2X"
    "General.Light2Y"
    "General.Light2Z"
    "General.Light2W"
    "General.Light3"
    "General.Light3X"
    "General.Light3Y"
    "General.Light3Z"
    "General.Light3W"
    "General.Light4"
    "General.Light4X"
    "General.Light4Y"
    "General.Light4Z"
    "General.Light4W"
    "General.Light5"
    "General.Light5X"
    "General.Light5Y"
    "General.Light5Z"
    "General.Light5W"
    "General.LineWidth"
    "General.ManipulatorPositionX"
    "General.ManipulatorPositionY"
    "General.MaxX"
    "General.MaxY"
    "General.MaxZ"
    "General.MenuWidth"
    "General.MenuHeight"
    "General.MenuPositionX"
    "General.MenuPositionY"
    "General.MessageFontSize"
    "General.MessageHeight"
    "General.MinX"
    "General.MinY"
    "General.MinZ"
    "General.MouseHoverMeshes"
    "General.MouseSelection"
    "General.MouseInvertZoom"
    "General.NativeFileChooser"
    "General.NonModalWindows"
    "General.NoPopup"
    "General.NumThreads"
    "General.OptionsPositionX"
    "General.OptionsPositionY"
    "General.Orthographic"
    "General.PluginPositionX"
    "General.PluginPositionY"
    "General.PluginHeight"
    "General.PluginWidth"
    "General.PointSize"
    "General.PolygonOffsetAlwaysOn"
    "General.PolygonOffsetFactor"
    "General.PolygonOffsetUnits"
    "General.ProgressMeterStep"
    "General.QuadricSubdivisions"
    "General.RotationX"
    "General.RotationY"
    "General.RotationZ"
    "General.RotationCenterGravity"
    "General.RotationCenterX"
    "General.RotationCenterY"
    "General.RotationCenterZ"
    "General.SaveOptions"
    "General.SaveSession"
    "General.ScaleX"
    "General.ScaleY"
    "General.ScaleZ"
    "General.Shininess"
    "General.ShininessExponent"
    "General.ShowModuleMenu"
    "General.ShowOptionsOnStartup"
    "General.ShowMessagesOnStartup"
    "General.SmallAxes"
    "General.SmallAxesPositionX"
    "General.SmallAxesPositionY"
    "General.SmallAxesSize"
    "General.StatisticsPositionX"
    "General.StatisticsPositionY"
    "General.Stereo"
    "General.SystemMenuBar"
    "General.Terminal"
    "General.Tooltips"
    "General.Trackball"
    "General.TrackballHyperbolicSheet"
    "General.TrackballQuaternion0"
    "General.TrackballQuaternion1"
    "General.TrackballQuaternion2"
    "General.TrackballQuaternion3"
    "General.TranslationX"
    "General.TranslationY"
    "General.TranslationZ"
    "General.VectorType"
    "General.Verbosity"
    "General.VisibilityPositionX"
    "General.VisibilityPositionY"
    "General.ZoomFactor"
    "General.Color.Background"
    "General.Color.BackgroundGradient"
    "General.Color.Foreground"
    "General.Color.Text"
    "General.Color.Axes"
    "General.Color.SmallAxes"
    "General.Color.AmbientLight"
    "General.Color.DiffuseLight"
    "General.Color.SpecularLight"

    "Print.ParameterCommand"
    "Print.Parameter"
    "Print.ParameterFirst"
    "Print.ParameterLast"
    "Print.ParameterSteps"
    "Print.Background"
    "Print.CompositeWindows"
    "Print.DeleteTemporaryFiles"
    "Print.EpsBestRoot"
    "Print.EpsCompress"
    "Print.EpsLineWidthFactor"
    "Print.EpsOcclusionCulling"
    "Print.EpsPointSizeFactor"
    "Print.EpsPS3Shading"
    "Print.EpsQuality"
    "Print.Format"
    "Print.GeoLabels"
    "Print.GeoOnlyPhysicals"
    "Print.GifDither"
    "Print.GifInterlace"
    "Print.GifSort"
    "Print.GifTransparent"
    "Print.Height"
    "Print.JpegQuality"
    "Print.JpegSmoothing"
    "Print.PgfTwoDim"
    "Print.PgfExportAxis"
    "Print.PgfHorizontalBar"
    "Print.PostElementary"
    "Print.PostElement"
    "Print.PostGamma"
    "Print.PostEta"
    "Print.PostSICN"
    "Print.PostSIGE"
    "Print.PostDisto"
    "Print.TexAsEquation"
    "Print.TexForceFontSize"
    "Print.TexWidthInMm"
    "Print.Text"
    "Print.X3dCompatibility"
    "Print.X3dPrecision"
    "Print.X3dRemoveInnerBorders"
    "Print.X3dTransparency"
    "Print.X3dSurfaces"
    "Print.X3dEdges"
    "Print.X3dVertices"
    "Print.Width"

    "Geometry.DoubleClickedPointCommand"
    "Geometry.DoubleClickedCurveCommand"
    "Geometry.DoubleClickedSurfaceCommand"
    "Geometry.DoubleClickedVolumeCommand"
    "Geometry.OCCTargetUnit"
    "Geometry.AutoCoherence"
    "Geometry.Clip"
    "Geometry.CopyMeshingMethod"
    "Geometry.Curves"
    "Geometry.CurveLabels"
    "Geometry.CurveSelectWidth"
    "Geometry.CurveType"
    "Geometry.CurveWidth"
    "Geometry.DoubleClickedEntityTag"
    "Geometry.ExactExtrusion"
    "Geometry.ExtrudeReturnLateralEntities"
    "Geometry.ExtrudeSplinePoints"
    "Geometry.HighlightOrphans"
    "Geometry.LabelType"
    "Geometry.Light"
    "Geometry.LightTwoSide"
    "Geometry.MatchGeomAndMesh"
    "Geometry.MatchMeshScaleFactor"
    "Geometry.MatchMeshTolerance"
    "Geometry.Normals"
    "Geometry.NumSubEdges"
    "Geometry.OCCAutoEmbed"
    "Geometry.OCCAutoFix"
    "Geometry.OCCBooleanPreserveNumbering"
    "Geometry.OCCBoundsUseStl"
    "Geometry.OCCDisableStl"
    "Geometry.OCCFixDegenerated"
    "Geometry.OCCFixSmallEdges"
    "Geometry.OCCFixSmallFaces"
    "Geometry.OCCImportLabels"
    "Geometry.OCCMakeSolids"
    "Geometry.OCCParallel"
    "Geometry.OCCScaling"
    "Geometry.OCCSewFaces"
    "Geometry.OCCThruSectionsDegree"
    "Geometry.OCCUnionUnify"
    "Geometry.OCCUseGenericClosestPoint"
    "Geometry.OffsetX"
    "Geometry.OffsetY"
    "Geometry.OffsetZ"
    "Geometry.OldCircle"
    "Geometry.OldRuledSurface"
    "Geometry.OldNewReg"
    "Geometry.OrientedPhysicals"
    "Geometry.Points"
    "Geometry.PointLabels"
    "Geometry.PointSelectSize"
    "Geometry.PointSize"
    "Geometry.PointType"
    "Geometry.ReparamOnFaceRobust"
    "Geometry.ScalingFactor"
    "Geometry.SnapPoints"
    "Geometry.SnapX"
    "Geometry.SnapY"
    "Geometry.SnapZ"
    "Geometry.Surfaces"
    "Geometry.SurfaceLabels"
    "Geometry.SurfaceType"
    "Geometry.Tangents"
    "Geometry.Tolerance"
    "Geometry.ToleranceBoolean"
    "Geometry.Transform"
    "Geometry.TransformXX"
    "Geometry.TransformXY"
    "Geometry.TransformXZ"
    "Geometry.TransformYX"
    "Geometry.TransformYY"
    "Geometry.TransformYZ"
    "Geometry.TransformZX"
    "Geometry.TransformZY"
    "Geometry.TransformZZ"
    "Geometry.Volumes"
    "Geometry.VolumeLabels"
    "Geometry.Color.Points"
    "Geometry.Color.Curves"
    "Geometry.Color.Surfaces"
    "Geometry.Color.Volumes"
    "Geometry.Color.Selection"
    "Geometry.Color.HighlightZero"
    "Geometry.Color.HighlightOne"
    "Geometry.Color.HighlightTwo"
    "Geometry.Color.Tangents"
    "Geometry.Color.Normals"
    "Geometry.Color.Projection"

    "Mesh.Algorithm"
    "Mesh.Algorithm3D"
    "Mesh.AlgorithmSwitchOnFailure"
    "Mesh.AngleSmoothNormals"
    "Mesh.AngleToleranceFacetOverlap"
    "Mesh.AnisoMax"
    "Mesh.AllowSwapAngle"
    "Mesh.BdfFieldFormat"
    "Mesh.Binary"
    "Mesh.BoundaryLayerFanElements"
    "Mesh.CgnsImportOrder"
    "Mesh.CgnsImportIgnoreBC"
    "Mesh.CgnsImportIgnoreSolution"
    "Mesh.CgnsConstructTopology"
    "Mesh.CgnsExportCPEX0045"
    "Mesh.CgnsExportStructured"
    "Mesh.Clip"
    "Mesh.ColorCarousel"
    "Mesh.CompoundClassify"
    "Mesh.CompoundMeshSizeFactor"
    "Mesh.CpuTime"
    "Mesh.CreateTopologyMsh2"
    "Mesh.DrawSkinOnly"
    "Mesh.Dual"
    "Mesh.ElementOrder"
    "Mesh.Explode"
    "Mesh.FirstElementTag"
    "Mesh.FirstNodeTag"
    "Mesh.FlexibleTransfinite"
    "Mesh.Format"
    "Mesh.Hexahedra"
    "Mesh.HighOrderDistCAD"
    "Mesh.HighOrderIterMax"
    "Mesh.HighOrderNumLayers"
    "Mesh.HighOrderOptimize"
    "Mesh.HighOrderPassMax"
    "Mesh.HighOrderPeriodic"
    "Mesh.HighOrderPoissonRatio"
    "Mesh.HighOrderSavePeriodic"
    "Mesh.HighOrderPrimSurfMesh"
    "Mesh.HighOrderThresholdMin"
    "Mesh.HighOrderThresholdMax"
    "Mesh.HighOrderFastCurvingNewAlgo"
    "Mesh.HighOrderCurveOuterBL"
    "Mesh.HighOrderMaxRho"
    "Mesh.HighOrderMaxAngle"
    "Mesh.HighOrderMaxInnerAngle"
    "Mesh.IgnoreParametrization"
    "Mesh.IgnorePeriodicity"
    "Mesh.LabelSampling"
    "Mesh.LabelType"
    "Mesh.LcIntegrationPrecision"
    "Mesh.Light"
    "Mesh.LightLines"
    "Mesh.LightTwoSide"
    "Mesh.Lines"
    "Mesh.LineLabels"
    "Mesh.LineWidth"
    "Mesh.MaxIterDelaunay3D"
    "Mesh.MaxNumThreads1D"
    "Mesh.MaxNumThreads2D"
    "Mesh.MaxNumThreads3D"
    "Mesh.MaxRetries"
    "Mesh.MeshOnlyVisible"
    "Mesh.MeshOnlyEmpty"
    "Mesh.MeshSizeExtendFromBoundary"
    "Mesh.MeshSizeFactor"
    "Mesh.MeshSizeMin"
    "Mesh.MeshSizeMax"
    "Mesh.MeshSizeFromCurvature"
    "Mesh.MeshSizeFromCurvatureIsotropic"
    "Mesh.MeshSizeFromPoints"
    "Mesh.MeshSizeFromParametricPoints"
    "Mesh.MetisAlgorithm"
    "Mesh.MetisEdgeMatching"
    "Mesh.MetisMaxLoadImbalance"
    "Mesh.MetisObjective"
    "Mesh.MetisMinConn"
    "Mesh.MetisRefinementAlgorithm"
    "Mesh.MinimumCircleNodes"
    "Mesh.MinimumCurveNodes"
    "Mesh.MinimumElementsPerTwoPi"
    "Mesh.MshFileVersion"
    "Mesh.MedFileMinorVersion"
    "Mesh.MedImportGroupsOfNodes"
    "Mesh.MedSingleModel"
    "Mesh.NbHexahedra"
    "Mesh.NbNodes"
    "Mesh.NbPartitions"
    "Mesh.NbPrisms"
    "Mesh.NbPyramids"
    "Mesh.NbTrihedra"
    "Mesh.NbQuadrangles"
    "Mesh.NbTetrahedra"
    "Mesh.NbTriangles"
    "Mesh.NewtonConvergenceTestXYZ"
    "Mesh.Nodes"
    "Mesh.NodeLabels"
    "Mesh.NodeSize"
    "Mesh.NodeType"
    "Mesh.Normals"
    "Mesh.NumSubEdges"
    "Mesh.Optimize"
    "Mesh.OptimizeThreshold"
    "Mesh.OptimizeNetgen"
    "Mesh.PartitionHexWeight"
    "Mesh.PartitionLineWeight"
    "Mesh.PartitionPrismWeight"
    "Mesh.PartitionPyramidWeight"
    "Mesh.PartitionQuadWeight"
    "Mesh.PartitionTrihedronWeight"
    "Mesh.PartitionTetWeight"
    "Mesh.PartitionTriWeight"
    "Mesh.PartitionCreateTopology"
    "Mesh.PartitionCreatePhysicals"
    "Mesh.PartitionCreateGhostCells"
    "Mesh.PartitionSplitMeshFiles"
    "Mesh.PartitionTopologyFile"
    "Mesh.PartitionOldStyleMsh2"
    "Mesh.PartitionConvertMsh2"
    "Mesh.PreserveNumberingMsh2"
    "Mesh.Prisms"
    "Mesh.Pyramids"
    "Mesh.Trihedra"
    "Mesh.QuadqsSizemapMethod"
    "Mesh.QuadqsTopologyOptimizationMethods"
    "Mesh.QuadqsRemeshingBoldness"
    "Mesh.Quadrangles"
    "Mesh.QualityInf"
    "Mesh.QualitySup"
    "Mesh.QualityType"
    "Mesh.RadiusInf"
    "Mesh.RadiusSup"
    "Mesh.RandomFactor"
    "Mesh.RandomFactor3D"
    "Mesh.RandomSeed"
    "Mesh.ReadGroupsOfElements"
    "Mesh.RecombinationAlgorithm"
    "Mesh.RecombineAll"
    "Mesh.RecombineOptimizeTopology"
    "Mesh.Recombine3DAll"
    "Mesh.Recombine3DLevel"
    "Mesh.Recombine3DConformity"
    "Mesh.RefineSteps"
    "Mesh.Renumber"
    "Mesh.ReparamMaxTriangles"
    "Mesh.SaveAll"
    "Mesh.SaveElementTagType"
    "Mesh.SaveTopology"
    "Mesh.SaveParametric"
    "Mesh.SaveGroupsOfElements"
    "Mesh.SaveGroupsOfNodes"
    "Mesh.ScalingFactor"
    "Mesh.SecondOrderIncomplete"
    "Mesh.SecondOrderLinear"
    "Mesh.Smoothing"
    "Mesh.SmoothCrossField"
    "Mesh.CrossFieldClosestPoint"
    "Mesh.SmoothNormals"
    "Mesh.SmoothRatio"
    "Mesh.StlAngularDeflection"
    "Mesh.StlLinearDeflection"
    "Mesh.StlOneSolidPerSurface"
    "Mesh.StlRemoveDuplicateTriangles"
    "Mesh.SubdivisionAlgorithm"
    "Mesh.SurfaceEdges"
    "Mesh.SurfaceFaces"
    "Mesh.SurfaceLabels"
    "Mesh.SwitchElementTags"
    "Mesh.Tangents"
    "Mesh.Tetrahedra"
    "Mesh.ToleranceEdgeLength"
    "Mesh.ToleranceInitialDelaunay"
    "Mesh.Triangles"
    "Mesh.UnvStrictFormat"
    "Mesh.VolumeEdges"
    "Mesh.VolumeFaces"
    "Mesh.VolumeLabels"
    "Mesh.Voronoi"
    "Mesh.ZoneDefinition"
    "Mesh.Color.Nodes"
    "Mesh.Color.NodesSup"
    "Mesh.Color.Lines"
    "Mesh.Color.Triangles"
    "Mesh.Color.Quadrangles"
    "Mesh.Color.Tetrahedra"
    "Mesh.Color.Hexahedra"
    "Mesh.Color.Prisms"
    "Mesh.Color.Pyramids"
    "Mesh.Color.Trihedra"
    "Mesh.Color.Tangents"
    "Mesh.Color.Normals"
    "Mesh.Color.Zero"
    "Mesh.Color.One"
    "Mesh.Color.Two"
    "Mesh.Color.Three"
    "Mesh.Color.Four"
    "Mesh.Color.Five"
    "Mesh.Color.Six"
    "Mesh.Color.Seven"
    "Mesh.Color.Eight"
    "Mesh.Color.Nine"
    "Mesh.Color.Ten"
    "Mesh.Color.Eleven"
    "Mesh.Color.Twelve"
    "Mesh.Color.Thirteen"
    "Mesh.Color.Fourteen"
    "Mesh.Color.Fifteen"
    "Mesh.Color.Sixteen"
    "Mesh.Color.Seventeen"
    "Mesh.Color.Eighteen"
    "Mesh.Color.Nineteen"

    "Solver.Executable0"
    "Solver.Executable1"
    "Solver.Executable2"
    "Solver.Executable3"
    "Solver.Executable4"
    "Solver.Executable5"
    "Solver.Executable6"
    "Solver.Executable7"
    "Solver.Executable8"
    "Solver.Executable9"
    "Solver.Name0"
    "Solver.Name1"
    "Solver.Name2"
    "Solver.Name3"
    "Solver.Name4"
    "Solver.Name5"
    "Solver.Name6"
    "Solver.Name7"
    "Solver.Name8"
    "Solver.Name9"
    "Solver.Extension0"
    "Solver.Extension1"
    "Solver.Extension2"
    "Solver.Extension3"
    "Solver.Extension4"
    "Solver.Extension5"
    "Solver.Extension6"
    "Solver.Extension7"
    "Solver.Extension8"
    "Solver.Extension9"
    "Solver.OctaveInterpreter"
    "Solver.PythonInterpreter"
    "Solver.RemoteLogin0"
    "Solver.RemoteLogin1"
    "Solver.RemoteLogin2"
    "Solver.RemoteLogin3"
    "Solver.RemoteLogin4"
    "Solver.RemoteLogin5"
    "Solver.RemoteLogin6"
    "Solver.RemoteLogin7"
    "Solver.RemoteLogin8"
    "Solver.RemoteLogin9"
    "Solver.SocketName"
    "Solver.AlwaysListen"
    "Solver.AutoArchiveOutputFiles"
    "Solver.AutoCheck"
    "Solver.AutoLoadDatabase"
    "Solver.AutoSaveDatabase"
    "Solver.AutoMesh"
    "Solver.AutoMergeFile"
    "Solver.AutoShowViews"
    "Solver.AutoShowLastStep"
    "Solver.Plugins"
    "Solver.ShowInvisibleParameters"
    "Solver.Timeout"
    "PostProcessing.DoubleClickedGraphPointCommand"
    "PostProcessing.GraphPointCommand"
    "PostProcessing.AnimationDelay"
    "PostProcessing.AnimationCycle"
    "PostProcessing.AnimationStep"
    "PostProcessing.CombineRemoveOriginal"
    "PostProcessing.CombineCopyOptions"
    "PostProcessing.DoubleClickedGraphPointX"
    "PostProcessing.DoubleClickedGraphPointY"
    "PostProcessing.DoubleClickedView"
    "PostProcessing.ForceElementData"
    "PostProcessing.ForceNodeData"
    "PostProcessing.Format"
    "PostProcessing.GraphPointX"
    "PostProcessing.GraphPointY"
    "PostProcessing.HorizontalScales"
    "PostProcessing.Link"
    "PostProcessing.NbViews"
    "PostProcessing.Plugins"
    "PostProcessing.SaveInterpolationMatrices"
    "PostProcessing.SaveMesh"
    "PostProcessing.Smoothing"
    "View.Attributes"
    "View.AxesFormatX"
    "View.AxesFormatY"
    "View.AxesFormatZ"
    "View.AxesLabelX"
    "View.AxesLabelY"
    "View.AxesLabelZ"
    "View.DoubleClickedCommand"
    "View.FileName"
    "View.Format"
    "View.GeneralizedRaiseX"
    "View.GeneralizedRaiseY"
    "View.GeneralizedRaiseZ"
    "View.Group"
    "View.Name"
    "View.Stipple0"
    "View.Stipple1"
    "View.Stipple2"
    "View.Stipple3"
    "View.Stipple4"
    "View.Stipple5"
    "View.Stipple6"
    "View.Stipple7"
    "View.Stipple8"
    "View.Stipple9"
    "View.AbscissaRangeType"
    "View.AdaptVisualizationGrid"
    "View.AngleSmoothNormals"
    "View.ArrowSizeMax"
    "View.ArrowSizeMin"
    "View.AutoPosition"
    "View.Axes"
    "View.AxesMikado"
    "View.AxesAutoPosition"
    "View.AxesMaxX"
    "View.AxesMaxY"
    "View.AxesMaxZ"
    "View.AxesMinX"
    "View.AxesMinY"
    "View.AxesMinZ"
    "View.AxesTicsX"
    "View.AxesTicsY"
    "View.AxesTicsZ"
    "View.Boundary"
    "View.CenterGlyphs"
    "View.Clip"
    "View.Closed"
    "View.ColormapAlpha"
    "View.ColormapAlphaPower"
    "View.ColormapBeta"
    "View.ColormapBias"
    "View.ColormapCurvature"
    "View.ColormapInvert"
    "View.ColormapNumber"
    "View.ColormapRotation"
    "View.ColormapSwap"
    "View.ComponentMap0"
    "View.ComponentMap1"
    "View.ComponentMap2"
    "View.ComponentMap3"
    "View.ComponentMap4"
    "View.ComponentMap5"
    "View.ComponentMap6"
    "View.ComponentMap7"
    "View.ComponentMap8"
    "View.CustomAbscissaMax"
    "View.CustomAbscissaMin"
    "View.CustomMax"
    "View.CustomMin"
    "View.DisplacementFactor"
    "View.DrawHexahedra"
    "View.DrawLines"
    "View.DrawPoints"
    "View.DrawPrisms"
    "View.DrawPyramids"
    "View.DrawTrihedra"
    "View.DrawQuadrangles"
    "View.DrawScalars"
    "View.DrawSkinOnly"
    "View.DrawStrings"
    "View.DrawTensors"
    "View.DrawTetrahedra"
    "View.DrawTriangles"
    "View.DrawVectors"
    "View.Explode"
    "View.ExternalView"
    "View.FakeTransparency"
    "View.ForceNumComponents"
    "View.GeneralizedRaiseFactor"
    "View.GeneralizedRaiseView"
    "View.GlyphLocation"
    "View.Height"
    "View.IntervalsType"
    "View.Light"
    "View.LightLines"
    "View.LightTwoSide"
    "View.LineType"
    "View.LineWidth"
    "View.MaxRecursionLevel"
    "View.Max"
    "View.MaxVisible"
    "View.MaxX"
    "View.MaxY"
    "View.MaxZ"
    "View.Min"
    "View.MinVisible"
    "View.MinX"
    "View.MinY"
    "View.MinZ"
    "View.NbIso"
    "View.NbTimeStep"
    "View.NormalRaise"
    "View.Normals"
    "View.OffsetX"
    "View.OffsetY"
    "View.OffsetZ"
    "View.PointSize"
    "View.PointType"
    "View.PositionX"
    "View.PositionY"
    "View.RaiseX"
    "View.RaiseY"
    "View.RaiseZ"
    "View.RangeType"
    "View.Sampling"
    "View.SaturateValues"
    "View.ScaleType"
    "View.ShowElement"
    "View.ShowScale"
    "View.ShowTime"
    "View.SmoothNormals"
    "View.Stipple"
    "View.Tangents"
    "View.TargetError"
    "View.TensorType"
    "View.TimeStep"
    "View.Time"
    "View.TransformXX"
    "View.TransformXY"
    "View.TransformXZ"
    "View.TransformYX"
    "View.TransformYY"
    "View.TransformYZ"
    "View.TransformZX"
    "View.TransformZY"
    "View.TransformZZ"
    "View.Type"
    "View.UseGeneralizedRaise"
    "View.VectorType"
    "View.Visible"
    "View.Width"
    "View.Color.Points"
    "View.Color.Lines"
    "View.Color.Triangles"
    "View.Color.Quadrangles"
    "View.Color.Tetrahedra"
    "View.Color.Hexahedra"
    "View.Color.Prisms"
    "View.Color.Pyramids"
    "View.Color.Trihedra"
    "View.Color.Tangents"
    "View.Color.Normals"
    "View.Color.Text2D"
    "View.Color.Text3D"
    "View.Color.Axes"
    "View.Color.Background2D"
    "View.ColorTable")

  "Constant identifiers common to gmsh and getdp")

(defvar gmsh/getdp-obsolete-constants-list
    ;; the following paragraph has  not documented in (gmsh)Appendix B Options
    ;; TODO: verify, the following contigues lines can be
    ;;  - still valid but never documented,
    ;;  - obsolete or
    ;;  - wrong
    ;; was present in gmsh/getdp-constants-list but actually not documented in 4.9.0
  '(
    "Geometry.HideCompounds"
    "Geometry.Lines"
    "Geometry.LineNumbers"
    "Geometry.LineSelectWidth"
    "Geometry.LineType"
    "Geometry.LineWidth"
    "Geometry.PointNumbers"
    "Geometry.SurfaceNumbers"
    "Geometry.VolumeNumbers"
    "Geometry.Color" ;this exists as category
    "Mesh.Bunin"
    "Mesh.Lloyd"
    "Mesh.CharacteristicLengthFactor" ; removed between 2.3 and 2.8.5
    "Mesh.HighOrderSmoothingThreshold"
    "Mesh.LineNumbers"
    "Mesh.MinimumCirclePoints"
    "Mesh.MinimumCurvePoints"
    "Mesh.MshFilePartitioned"
    "Mesh.MultiplePassesMeshes"
    "Mesh.Partitioner"
    "Mesh.Points"
    "Mesh.PointNumbers"
    "Mesh.PointSize"
    "Mesh.PointType"
    "Mesh.IgnorePartitionBoundary"
    "Mesh.RemeshAlgorithm"
    "Mesh.RemeshParametrization"
    "Mesh.Remove4Triangles"
    "Mesh.ReverseAllNormals"
    "Mesh.SecondOrderExperimental"
    "Mesh.SurfaceNumbers"
    "Mesh.VolumeNumbers"
    "Mesh.CharacteristicLengthMin"
    "Mesh.CharacteristicLengthMax")
  "Options removed at least in 4.9+")

;TODO: add space separed keywords as "Curve Loop" "Physical Loop"
(defvar gmsh-keywords-list
  '("Return" "Call" "Exit"
    "Include" "SetName" "NonBlockingSystemCall" "SystemCall" "Sleep" "Mesh" "Delete" "BoundingBox" "Merge" "Error"
    "Point" "Physical" "Line" "Loop" "Surface" "Volume" "Compound" "Plane" "Ruled" "Circle" "Ellipse"
    "T2" "T3" "SP" "VP" "TP" "SL" "VL" "TL" "ST" "VT" "TT" "SQ" "VQ" "TQ"
    "SS" "VS" "TS" "SH" "VH" "TH"  "SI" "VI" "TI" "SY" "VY" "TY" "DefineConstant"
    "SetFactory" "Spline" "BSpline" "Block" "Rectangle" "Disk" "Cone" "Wedge" "Sphere" "Box" "Cylinder" "Torus" "ThruSections" "Ruled ThruSections"
    "Compound Surface" "Compound Volume" "Using Wire" "Wire" "Fillet")
  "Gmsh key words")
(defvar gmsh-keywords2-list
  '("newp" "newl" "news" "newv" "newll" "newsl" "newreg"
    "Red" "Blue" "Yellow" "Green" "Orange" "Cyan" "Magneta" "ForestGreen" "SpringGreen" "Gold" "PaleGoldenrod"
    "Pink" "NavyBlue" "Royal Blue" "LightYellow" "LightGreen" "AliceBlue" "Magenta" "Violet" "Orchid" "LightGrey")
  "Gmsh key words2")

(defvar gmsh-functions-list
  '(
    "Extrude" "Dilate" "Rotate" "Symmetry" "Translate" "Boundary" "CombinedBoundary" "Duplicata"
    "Hide" "Show" "TextAttributes"  "Plugin" "Alias" "Combine"
    "BooleanIntersection" "BooleanUnion" "BooleanFragments" "BooleanDifference" "PointsOf"
    )
  "List of function identifiers specific to Gmsh (see also `gmsh/getdp-functions-list').")

(defvar gmsh-constants-list
  '()
  "Gmsh constants.")

(defvar getdp-keywords-list
  '(
    "Type" "TimeFunction" "Value" "Galerkin" "ChangeOfCoordinates" "ChangeOfValues" "InitSolution" "Generate" "GenerateJac" "GenerateOnly" "GenerateOnlyJac" "GenerateSeparate" "SaveSolution" "SaveSolutions" "SetFrequency" "SetTime" "Solve" "SolveJac" "EigenSolve" "IterativeLoop" "IterativeLoopN" "TimeLoopAdaptive" "TimeLoopNewmark" "TimeLoopTheta"
    ;; keywords associated to objects:
    "Analytic" "BasisFunction" "Case" "Constraint" "Criterion" "DefineFunction" "DefineVariable" "DefineConstant" "DefineGroup" "DestinationSystem" "Entity" "EntitySubType" "EntityType" "Equation" "File" "Format" "Formulation" "Frequency" "Function" "FunctionSpace" "GeoElement" "GlobalEquation" "GlobalQuantity" "GlobalTerm" "Group" "In" "IndexOfSystem" "Integral" "Integration" "Jacobian" "Loop" "Name" "NameOfBasisFunction" "NameOfCoef" "NameOfConstraint" "NameOfFormulation" "NameOfMesh" "NameOfPostProcessing" "NameOfSpace" "NameOfSystem" "Node" "NumberOfPoints" "Operation" "OriginSystem" "PostOperation" "PostProcessing" "Quantity" "Region" "RegionRef" "Resolution" "Solver" "SubRegion" "SubRegionRef" "SubSpace" "Support" "Symmetry" "System" "LastTimeStepOnly" "AppendTimeStepToFileName" "OverrideTimeStepValue" "UsingPost" "Append" "MovingBand2D" "MeshMovingBand2D" "InitMovingBand2D" "DeleteFile" "Coefficient" "SendToServer" "Store" "ComputeCommand" "ResolutionChoices" "PostOperationChoices"
    )
  "List of keyword identifiers specific to getdp (see also `gmsh/getdp-keywords-list')")

(defvar getdp-keywords-list-types
  '(
    "All" "Point" "Line" "Triangle" "Quadrangle" "Prism" "Pyramid" "Tetrahedron" "Hexahedron" "Not" 
    "Vol" "VolAxi" "VolAxiRectShell" "VolAxiSphShell" "VolAxiSqu" "VolAxiSquRectShell" "VolAxiSquSphShell" "VolRectShell" "VolSphShell" "Sur" "SurAxi" "Lin" "Form0" "Form1" "Form1P" "Form2" "Form2P" "Form3" 

    ;; Types of:
    "Adapt" "Adaptation" "AliasOf" "Assign" "AssignFromResolution" "AssociatedWith" "BF_CurlEdge" "BF_CurlGroupOfEdges" "BF_CurlGroupOfPerpendicularEdge" "BF_CurlPerpendicularEdge" "BF_dGlobal" "BF_DivFacet" "BF_DivPerpendicularFacet" "BF_Edge" "BF_Facet" "BF_Global" "BF_GradGroupOfNodes" "BF_GradNode" "BF_GroupOfEdges" "BF_GroupOfNodes" "BF_GroupOfPerpendicularEdge" "BF_Node" "BF_NodeX" "BF_NodeY" "BF_NodeZ" "BF_Node_2E" "BF_NodeX_2E" "BF_NodeY_2E" "BF_NodeZ_2E" "BF_One" "BF_PerpendicularEdge" "BF_PerpendicularFacet" "BF_Region" "BF_RegionX" "BF_RegionY" "BF_RegionZ" "BF_Volume" "BF_VolumeX" "BF_VolumeY" "BF_VolumeZ" "BF_Zero" "Break" "DecomposeInSimplex" "Depth" "deRham" "Dimension" "DualEdgesOf" "DualFacetsOf" "DualNodesOf" "DualVolumesOf" "EdgesOf" "EdgesOfTreeIn"  "EigenvalueLegend" "ElementsOf" "Evaluate" "FacetsOf" "FacetsOfTreeIn" "FemEquation" "FourierTransform" "Frequency" "FrequencyLegend"  "Gauss" "GaussLegendre"  "Global" "Gmsh" "GmshParsed" "Gnuplot" "GroupsOfEdgesOf" "GroupsOfEdgesOnNodesOf" "GroupsOfNodesOf" "HarmonicToTime" "If" "Init" "InitFromResolution"  "Integral" "Integral" "Iso" "Lanczos" "Link" "LinkCplx" "Local" "Local" "Network" "NodesOf" "NodeTable" "NoNewLine" "OnBox" "OnElementsOf" "OnGlobal" "OnGrid" "OnLine" "OnPlane" "OnPoint" "OnRegion" "OnSection" "Point" "PostOperation" "Scalar" "SimpleTable" "Skin" "Smoothing"  "Sort" "StartingOn" "StoreInField" "StoreInRegister" "StoreInVariable" "SystemCommand" "Table" "Target"  "TimeLegend" "TimeStep" "TimeTable" "TransferInitSolution" "TransferSolution"  "Update" "UpdateConstraint" "Term" "VolumesOf"  "Local" 
    )
  "List of keyword identifiers specific to getdp (see also `gmsh/getdp-keywords-list')")

(defvar getdp-functions-list
  '("Log10" "Atan2" "Transpose" "TTrace" "Unit" "Complex" "CompX" "CompXX" "CompXY" "CompXZ" "CompY" "CompYX" "CompYY" "CompYZ" "CompZ" "CompZX" "CompZY" "CompZZ" "Im" "Re" "Conj" "Tensor" "TensorDiag" "TensorSym" "TensorV" "Vector" "SquDyadicProduct"
    ;;
    "Dt" "DtDof" "DtDofJacNL" "DtDt" "DtDtDof" "JacNL" "NeverDt" "List" "ListAlt" "h_Jiles" "dhdb_Jiles" "b_Jiles" "dbdh_Jiles"
    ;;
    "Cross" "F_Cos_wt_p" "F_Period" "F_Sin_wt_p" "Fabs" "Fmod" "Hypot" "Norm" "SquNorm" "SurfaceArea"
    ;; fields:
    "BF" "Curl" "CurlInv" "dInv" "Div" "DivInv" "Dof" "Grad" "GradInv" "Rot" "RotInv"
    ;; current Values:
    ;; "$DTime" "$EigenvalueImag" "$EigenvalueReal" "$Iteration" "$Theta" "$Time" "$TimeStep" "$X" "$XS" "$Y" "$YS" "$Z" "$ZS"
    ;; "X[]" "Y[]" "Z[]" "XYZ[]"
    ;; misc functions:
    "dInterpolationAkima" "dInterpolationLinear" "F_CompElementNum" "Order" "Rand"
    ;; Green functions:
    "Helmholtz" "Laplace"
    )
  "List with function identifiers specific to getdp (see also `gmsh/getdp-functions-list').")

(defvar getdp-constants-list
  '("0D" "1D" "2D" "3D" 
    ;; current Values:
    "$DTime" "$EigenvalueImag" "$EigenvalueReal" "$Iteration" "$Theta" "$Time" "$TimeStep" "$X" "$XS" "$Y" "$YS" "$Z" "$ZS" "X[]" "Y[]" "Z[]" "XYZ[]" 
    )
  "Getdp constants and current values.")

(defvar gmsh/getdp-block-statements '(("For" "EndFor")
				      ("If" "EndIf")
                                      ("If" "Else")
                                      ("If" "ElseIf")
                                      ("Else" "EndIf")
                                      ("ElseIf" "ElseIf")
                                      ("ElseIf" "Else")
                                      ("ElseIf" "EndIf")
				      ("Macro" "Return")
                                      )
  "List of block statements that are common to gmsh and getdp.
This list is mainly used for indentation.  Each entry is a list
with the begin and end statement for a block.")

(defvar gmsh-block-statements  '(;actually empty ("" "")
				 )
  "Gmsh specific block statements, not valid in GetDP.
Use the variable gmsh/getdp-block-statements for statements delimiters
that are common to both.
In each entry the first element is the block start the second the block end.")

(defvar getdp-block-statements '(("Function" "Return"))
  "GetDP block statements. Mainly for indentation.
In each entry the first element is the block start the second the block end.")

(defun gmsh/getdp-highlight-In-after-For (lim)
  "Find In after For"
  (interactive)
  (let (found)
    (catch 0
      (while (setq found (search-forward-regexp "\\_<In\\_>" lim 'noErr))
	(and
	 (null (syntax-ppss-context (syntax-ppss)))
	 (let ((inhibit-changing-match-data t)) (looking-back "\\_<For[[:blank:]]+\\(\\sw\\|\\s_\\)+[[:blank:]]+In"))
	 (throw 0 found))))))

(defun getdp-highlight-Vector (lim)
  "Find Vector after Type"
  (interactive)
  (let (found)
    (catch 0
      (while (setq found (search-forward-regexp "\\_<Vector\\_>" lim 'noErr))
	(and
	 (null (syntax-ppss-context (syntax-ppss)))
	 (let ((inhibit-changing-match-data t)) (looking-back "\\_<Type[[:blank:]]+Vector"))
	 (throw 0 found))))))

(defun getdp-highlight-Region (lim)
  "Find Region after EntityType"
  (interactive)
  (let (found)
    (catch 0
      (while (setq found (search-forward-regexp "\\_<Region\\_>" lim 'noErr))
	(and
	 (null (syntax-ppss-context (syntax-ppss)))
	 (let ((inhibit-changing-match-data t)) (looking-back "\\_<EntityType[[:blank:]]+Region"))
	 (throw 0 found))))))




(defvar indent-amount 2
  "Number of columns to insert additionally for each indentation level.")

(defun nonspace-before (p)
  "Return list (c p l) with character c position p and number of
lines l when traveling backwards stopping at position p behind
the first non-space character c. Thereby, l is the number of
lines passed on the way."
  (let (c (l 0))
    (while (and
	    (setq c (char-before p))
	    (or (when (= c ?\n) (setq l (1+ l)))
		(= (char-syntax c) ?\ )))
      (setq p (1- p)))
    (list c p l)))

(defvar indent-relative-blocks nil
  "List of block statement descriptions recognized by `indent-relative-function'.
Each block statement description is itself a list containing two
strings.  The first string is the identifier for the beginning of
the block the second that one for the end.")

(make-variable-buffer-local 'indent-relative-blocks)

(defun indent-relative-function ()
  "Indent current line relative to previous one."
  (interactive)
  (save-excursion
    (if (eq (syntax-ppss-context (syntax-ppss ;; note: syntax-ppss can move point!
				  (line-beginning-position))) 'string)
	'noindent ;; line starts in string ==> return 'noindent
      ;; calculate indent level
      ;; search for the previous non-empty line:
      (let (b e prevIndent relDepth (p (point))
	      to
	      (re-block (regexp-opt (apply 'append indent-relative-blocks) 'words))
	      (re-end (concat "\\(\\s)\\|" (regexp-opt (mapcar 'cadr indent-relative-blocks) 'words) "\\)")))
	(save-excursion
	  (setq relDepth (syntax-ppss-depth (syntax-ppss)))
	  (beginning-of-line (- 1 (nth 2 (nonspace-before (line-beginning-position)))))
	  (setq prevIndent (current-indentation))
	  (move-to-column prevIndent)
	  (setq relDepth (- relDepth (syntax-ppss-depth (syntax-ppss))))
	  (when (and
		 (null (member (syntax-ppss-context (syntax-ppss)) '(string comment)))
		 (looking-at-p re-end))
	    (setq relDepth (1+ relDepth)))
	  ;; look for block keywords:
	  (setq e (line-end-position))
	  (while (search-forward-regexp re-block e 'noErr)
	    (unless (syntax-ppss-context (syntax-ppss))
	      (if (assoc (match-string-no-properties 0) indent-relative-blocks)
		  (setq relDepth (1+ relDepth))
		(setq relDepth (1- relDepth))
		))))
	(goto-char p)
	(beginning-of-line)
	(delete-horizontal-space)
	(when (looking-at-p re-end)
	  (setq relDepth (1- relDepth)))
	(setq to (+ prevIndent (* relDepth indent-amount)))
	(unless (= to (current-indentation))
	  (indent-to to)))))
  (when (< (current-column) (current-indentation))
    (move-to-column (current-indentation))))

(defmacro key-with-indent (k)
  "Define k as key with indent."
  (let ((sym (make-symbol (concat "electric-char-" (char-to-string k)))))
  `(progn
     (defun ,sym ()
       "Run `self-insert-command' and `indent-relative-function' for this character."
       (interactive)
       (self-insert-command 1)
       (indent-relative-function)
       )
     (local-set-key [,k] (quote ,sym))
     )))

(defun gmsh/getdp-common-settings ()
  "Common settings for gmsh and getdp."
  (setq font-lock-defaults (list
			    ;;;;;;;;;;
			    ;; KEYWORDS:
			    (list
			     ;;(cons (regexp-opt gmsh/getdp-keywords-list 'symbols) 'font-lock-keyword-face) ;; purple
                             (cons (regexp-opt gmsh/getdp-keywords-list 'symbols) 'font-lock-function-name-face) ;; purple
			     (cons (regexp-opt gmsh/getdp-functions-list 'symbols) 'font-lock-function-name-face) ;; blue
			     (cons (regexp-opt gmsh/getdp-constants-list 'symbols) 'font-lock-constant-face)
			     (cons (regexp-opt gmsh/getdp-obsolete-constants-list 'symbols) 'font-lock-warning-face)
			     ;;(cons 'gmsh/getdp-highlight-In-after-For 'font-lock-keyword-face)
                             (cons 'gmsh/getdp-highlight-In-after-For 'font-lock-function-name-face)
                             (cons 'getdp-highlight-Vector 'font-lock-type-face)
                             (cons 'getdp-highlight-Region 'font-lock-type-face))
			    ;;;;;;;;;;
			    nil ; keywords-only
			    nil ; case-fold
			    ;;;;;;;;;;
			    ;; syntax-list:
			    '(
			      ("_." . "w")
			      (?/ . ". 1456")
			      (?/ . ". 124b")
			      (?* . ". 23")
			      (?\n . "> b")
			      (?= . ".") (?+ . ".") (?- . ".")
			      (?$ . "_")
			      )
			    ))
  (local-set-key (kbd "<return>") '(lambda () (interactive) (newline) (indent-relative-function)))
  (key-with-indent ?}) (key-with-indent ?{)
  (key-with-indent ?() (key-with-indent ?))
  (key-with-indent ?[)  (key-with-indent ?])
  (setq indent-line-function 'indent-relative-function))

(if (version-list-< (version-to-list emacs-version) '(24 0))
    (defadvice regexp-opt (after symbols activate)
      (if (eq paren 'symbols)
	  (setq ad-return-value (concat "\\_<" ad-return-value "\\_>")))))

(defun last-cons (list)
  "Return last cons in list. Note, that list must contain at least one element."
  (unless (and list (listp list))
    (error "Call of last-cons with non-list or empty list argument."))
  (while (cdr list)
    (setq list (cdr list)))
  list)

(define-derived-mode gmsh-mode c++-mode "gmsh"
  "Major mode for editing gmsh geometry definitions."
  (gmsh/getdp-common-settings)
  (setcdr (last-cons (car font-lock-defaults))
	  (list (cons (regexp-opt gmsh-keywords-list 'symbols) 'font-lock-keyword-face) ;; purple
                (cons (regexp-opt gmsh-keywords2-list 'symbols) 'font-lock-type-face) ;; green
		(cons (regexp-opt gmsh-functions-list 'symbols) 'font-lock-function-name-face) ;; blue
		(cons (regexp-opt gmsh-constants-list 'symbols) 'font-lock-constant-face)
		))
  (setq indent-relative-blocks (append gmsh/getdp-block-statements gmsh-block-statements))
  (font-lock-mode 1)
  )

(define-derived-mode getdp-mode c++-mode "getdp"
  "Major mode for editing getdp geometry definitions."
  (gmsh/getdp-common-settings)
  (setcdr (last-cons (car font-lock-defaults))
	  (list (cons (regexp-opt getdp-keywords-list 'symbols) 'font-lock-keyword-face)
                (cons (regexp-opt getdp-keywords-list-types 'symbols) 'font-lock-type-face)
                (cons (regexp-opt getdp-functions-list 'symbols) 'font-lock-function-name-face) ;; blue
		(cons (regexp-opt getdp-constants-list 'symbols) 'font-lock-constant-face)
		))
  (setq indent-relative-blocks (append gmsh/getdp-block-statements getdp-block-statements))
  )

(add-to-list 'auto-mode-alist '("\\.pro\\'" . getdp-mode))
(add-to-list 'auto-mode-alist '("\\.geo\\'" . gmsh-mode))

(require 'info-look)

(info-lookup-add-help
 :mode 'getdp-mode
 :regexp "[[:alnum:]_]+"
 :doc-spec '(("(getdp)Syntax Index" nil "")))

(info-lookup-add-help
 :mode 'gmsh-mode
 :regexp "[[:alnum:]_]+"
 :doc-spec '(("(gmsh)Syntax Index" nil "")))

(defmacro stl2geo-vertex (pts cnt str name scale)
  "Read one vertex from stl file. Put it into hashtable pts with
index value cnt if it does not yet exist there else return its
index value in pts. Point moves behind the vertex."
  `(progn
     (search-forward "vertex")
     (let* ((b (current-buffer))
	    (pt (list (read b) (read b) (read b)))
	    (idx (gethash pt ,pts)))
       (unless idx
	 (puthash pt ,cnt ,pts)
	 (setq idx ,cnt)
	 (setq ,str (concat ,str "\np" ,name "[" (number-to-string idx) "]=newp; Point(p" ,name "[" (number-to-string idx) "])={"
			    (number-to-string (* ,scale (nth 0 pt))) ","
			    (number-to-string (* ,scale (nth 1 pt))) ","
			    (number-to-string (* ,scale (nth 2 pt))) ",mshSize};"))
	 (setq ,cnt (1+ ,cnt)))
       idx)))

(defmacro stl2geo-edge (edges p1 p2 cnt str name)
  `(let* (idx)
     (setq idx (gethash (cons ,p1 ,p2) ,edges))
     (unless idx
       (setq idx (gethash (cons ,p2 ,p1) ,edges))
       (when idx (setq idx (- idx))))
     (unless idx
       (puthash (cons ,p1 ,p2) ,cnt ,edges)
       (setq idx ,cnt)
       (setq ,str (concat ,str "\nl" ,name "[" (number-to-string idx) "]=newl; Line(l" ,name "[" (number-to-string idx)
			  "])={p" ,name "[" (number-to-string ,p1)
			  "],p" ,name "[" (number-to-string ,p2) "]};"))
       (setq ,cnt (1+ ,cnt)))
     idx))

(defun stl2geo (name scale geo)
  "Transformes stl grid of current buffer into gmsh geo file."
  (interactive "sName of entity:\nnScale factor:\nBGeo-buffer (without extension .geo):")
  (save-excursion
    (goto-char (point-min))
    (let* (facet
	   str
	   lineloop
	   (cntPts 0)
	   (cntEdges 1)
	   (cntLineLoop 0)
	   (size (/ (line-number-at-pos (point-max)) 7))
	   (pts (make-hash-table :test 'equal :size size))
	   (edges (make-hash-table :test 'equal :size size))
	   (geobuf (get-buffer-create geo)))
      (while (search-forward-regexp "^outer loop" nil 'noErr)
	(setq str nil)
	(setq facet (list (stl2geo-vertex pts cntPts str name scale)
			  (stl2geo-vertex pts cntPts str name scale)
			  (stl2geo-vertex pts cntPts str name scale)))
	(setq lineloop (list (stl2geo-edge edges (nth 0 facet) (nth 1 facet) cntEdges str name)
			     (stl2geo-edge edges (nth 1 facet) (nth 2 facet) cntEdges str name)
			     (stl2geo-edge edges (nth 2 facet) (nth 0 facet) cntEdges str name)))
	(setq str (concat str
			  "\nll" name "[" (number-to-string cntLineLoop) "]=newll; Line Loop(ll" name "[" (number-to-string cntLineLoop) "])={"
			  (if (< (nth 0 lineloop) 0 ) "-l" "l") name "[" (number-to-string (abs (nth 0 lineloop))) "],"
			  (if (< (nth 1 lineloop) 0 ) "-l" "l") name "[" (number-to-string (abs (nth 1 lineloop))) "],"
			  (if (< (nth 2 lineloop) 0 ) "-l" "l")  name "[" (number-to-string (abs (nth 2 lineloop))) "]};\n"
			  "s" name "[" (number-to-string cntLineLoop) "]=news; Plane Surface(s" name "[" (number-to-string cntLineLoop) "])={ll" name "[" (number-to-string cntLineLoop) "]};"
			  ))
	(setq cntLineLoop (1+ cntLineLoop))
	(with-current-buffer geobuf
	  (insert str)
	  )))))

(defun gmsh-import-stl (stl-file-name geo-entity-name scale)
  "Insert ASCII-STL mesh from file `stl-file-name' at point.
The geometrical entities are suffixed by `geo-entity-name'. The points are scaled by `scale'."
  (interactive "fSTL file:
sName suffix for geometrical entities:
nScale factor:")
  (let ((geo-buf (current-buffer)))
    (with-temp-buffer
      (insert-file-contents stl-file-name)
      (stl2geo geo-entity-name scale geo-buf))))

(easy-menu-define nil gmsh-mode-map
  "Menu for gmsh (import of ascii-stl)."
  '("Gmsh"
    ["Import ASCII STL" gmsh-import-stl t]))

(provide 'gmsh)

