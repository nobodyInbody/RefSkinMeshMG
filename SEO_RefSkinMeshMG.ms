/*
	2019-02-24 Va03
		단축키등록 추가
*/
struct RefSkinMesh
(
	setObjNum = #(),
	skinMeshs = #(),
	skinMeshNames = #(),
	isHideObjs = #(),
	
	fn isSkinModifier objVal =
	(
		local skinFound = false
		for i = 1 to objVal.modifiers.count do
		(
			if (classof objVal.modifiers[i] == Skin)or(classof objVal.modifiers[i] == Skin_Wrap) do
			(
				skinFound = true
			)
		)
		skinFound
	),
	fn findSkinMesh =
	(
		skinMeshs = #()
		skinMeshNames = #()
		isHideObjs = #()
		/*  
		_layerObjs = #()
		for i = 0 to layerManager.count-1 do
		(
			_aTemp = #()
			_ilayer = layerManager.getLayer i
			_layerHide = _ilayer.isHidden
			append _aTemp _layerHide

			_layer = ILayerManager.getLayerObject i -- 레퍼런스라 isSkinModifier 에서문제 생김
			_layerNodes = refs.dependents _layer
			append _aTemp _layerNodes
			for obj in _layerNodes do
			(
				if isSkinModifier obj do
					(
						local _isHide = "UnHide"
						append skinMeshs obj
						append skinMeshNames obj.name
						if obj.isHidden do
						(
							if _layerHide then
							(
								_isHide = "HideLayer"
							)	
							else
							(
								_isHide = "Hide"
							)
						)
		
						append isHideObjs _isHide
					)
			)
			append _layerObjs _aTemp
		)
		 */
		
		for obj in objects do
		(
			if isSkinModifier obj do
			(
				local _isHide = "UnHide"
				append skinMeshs obj
				append skinMeshNames obj.name
				if obj.isHidden do
				(
					_isHide = "Hide"
				)

				append isHideObjs _isHide
			)
		)
		
    ),
    fn skinMeshCount =
    (
        _count = skinMeshNames.count
        _count
    ),
	fn meshHide numVal =
	(
		hide skinMeshs[numVal]
		isHideObjs[numVal] = "Hide"	
	),
	fn meshUnhide numVal =
	(
		unhide skinMeshs[numVal]
		isHideObjs[numVal] = "UnHide"
	)
)
(
    if UIRefSkinMeshWindows != undefined do
    (
        DestroyDialog UIRefSkinMeshWindows
    )
	_MMG = RefSkinMesh()
	_UIWidth = 200
	_UIPos = mouse.screenpos -- [100,45]_
    rollout UIRefSkinMeshWindows  "RefMeshManager"
    (
		button btn초기화 "리셋" width:75 offset:[0, 0] align:#center
		label UIselectName "objName" offset:[0, 4] across:4 align:#Left
		label UIselectName2 ""  offset:[0, 0] align:#Right
		button btnHide "Hide" width:40 offset:[0, 0]
		button btnUnhide "UnHide" width:40 offset:[8, 0]
		--button btnSelect "선택" width:75 offset:[0, 0]
		multiListBox UIMeshList "" width:118 items:#() offset:[0, 0] align:#Left  across:3
		label UILabelHide "" offset:[0, 0] align:#center
		listbox UIisHide "" items:#() align:#center --readOnly:true

		fn UIReset = 
		(
			_MMG.findSkinMesh()
			local itemTexts = #()
			/* for i = 1 to _MMG.skinMeshNames.count do
			(
				append itemTexts (_MMG.skinMeshNames[i] + "   -   " + _MMG.isHideObjs[i])
			)
			UIMeshList.items = itemTexts
			 */
			UIMeshList.items = _MMG.skinMeshNames
			UIisHide.items = _MMG.isHideObjs
			
		)
        on UIRefSkinMeshWindows open do
        ( 
			_MMG = RefSkinMesh()
			UIReset()
        )
        on btn초기화 pressed do
        (
            DestroyDialog UIRefSkinMeshWindows
            createDialog UIRefSkinMeshWindows width:_UIWidth pos:_UIPos
        )
        on btnHide pressed do
        (
			try(
				for i in UIMeshList.selection do
				(
					_MMG.meshHide i
				)
				UIReset()
			)
			catch(UIReset())
        )
        on btnhide rightclick do
        (
			try(
				local _nTemp = _MMG.skinMeshs
				for i = 1 to _nTemp.count do
				(
					_MMG.meshHide i
				)
				UIReset()
			)
			catch(UIReset())
        )
		on btnUnhide pressed do
        (
			try(
				for i in UIMeshList.selection do
				(
					_MMG.meshUnhide i
				)
				UIReset()
			)
			catch(UIReset())
        )
        on btnUnhide rightclick do
        (
			try(
				local _nTemp = _MMG.skinMeshs
				for i = 1 to _nTemp.count do
				(
					_MMG.meshUnhide i
				)
				UIReset()
			)
			catch(UIReset())
        )
		on UIMeshList doubleClicked numVal do
		(
			try(
				select _MMG.skinMeshs[numVal]
			)
			catch(UIReset())
		)
		on UIMeshList selectionEnd do
		(
			try(
				local _objList = UIMeshList.selection as array
				local _objName = "objName"
				for obj in _objList do
				(
					_objName = _MMG.skinMeshNames[obj]
				)
				if UIMeshList.selection.numberSet > 1 do
				(
					_objName = _objName + "외 " + (UIMeshList.selection.numberSet as string) +"종"
				)
				UIselectName.text = _objName
			)
			catch(UIReset())
		)
		on UIMeshList selected numVal do
		(	
			try(
				local Temp = UIMeshList.selection as array
				if UIMeshList.selection[numVal] do
				(
					_MMG.setObjNum = numVal
				)
			)
			catch(UIReset())
		)
		on UIisHide selected numVal do
		(
			try(
				UIMeshList.selection = numVal
			)
			catch(UIReset())
		)
		on UIisHide doubleClicked numVal do
		(
			try(
				if _MMG.isHideObjs[numVal] == "Hide" then
				(
					_MMG.meshUnhide numVal
				)
				else
				(
					_MMG.meshHide numVal
				)
				UIReset()
			)
			catch(UIReset())
		)
    )
    createDialog UIRefSkinMeshWindows width:_UIWidth pos:_UIPos style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
)
macroScript RefSkinMeshMG
ButtonText:"RefSkinMeshMG"
category:"_AniSeoHyun"
tooltip:"RefSkinMeshMG"
icon:#("Maintoolbar", 11)
(
	on execute do
	(
		filein (getdir  #userScripts + "\\SEO_RefSkinMeshMG\\SEO_RefSkinMeshMG.ms")
	)
)