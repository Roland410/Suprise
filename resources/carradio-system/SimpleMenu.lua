iColorBlack = tocolor(0,0,0,255);
iColorWhite = tocolor(255,255,255,255);
iColorBlue  = tocolor(0,0,255,255);
iColorGreen = tocolor(0,255,0,255);
iColorRed   = tocolor(255,0,0,255);
iColorGay   = tocolor(255,0,255,255);
iColorBrown = tocolor(125,100,20,255);
iColorNone  = tocolor(0,0,0,0);

iDEF_FADI = 0;
iDEF_MOVE = 1;
iDEF_TRAN = 2;
iDEF_FADO = 3;


oBoxList = {}-- each box contains the following info: iStartX,iStartY,iWidth,iHeight,iFillColor,iBorderColor,iBorderWidth,bActive
oBoxList_functions = {};
oBoxList_boxesInEffects = {};

function oBoxList_functions.newBox(iStartX,iStartY,iWidth,iHeight,iFillColorR,iFillColorG,iFillColorB,iFillColorA,iBorderColorR,iBorderColorG,iBorderColorB,iBorderColorA,iBorderWidth,bActive)
	local iBoxID;
	iBoxID = 1;
	while oBoxList[iBoxID] do
		iBoxID = iBoxID + 1;
	end
	oBoxList[iBoxID] = {};
	oBoxList[iBoxID].iStartX = iStartX;
	oBoxList[iBoxID].iStartY = iStartY;
	oBoxList[iBoxID].iWidth  = iWidth;
	oBoxList[iBoxID].iHeight = iHeight;
	oBoxList[iBoxID].iFillColorR = iFillColorR;
	oBoxList[iBoxID].iFillColorG = iFillColorG;
	oBoxList[iBoxID].iFillColorB = iFillColorB;
	oBoxList[iBoxID].iFillColorA = iFillColorA;
	oBoxList[iBoxID].iBorderColorR = iBorderColorR;
	oBoxList[iBoxID].iBorderColorG = iBorderColorG;
	oBoxList[iBoxID].iBorderColorB = iBorderColorB;
	oBoxList[iBoxID].iBorderColorA = iBorderColorA;
	oBoxList[iBoxID].iBorderWidth = iBorderWidth;
	oBoxList[iBoxID].bActive = bActive;
	return iBoxID;
end

function oBoxList_functions.setBoxPosition(iBoxID,iStartX,iStartY)
	if oBoxList[iBoxID] then
		oBoxList[iBoxID].iStartX = iStartX;
		oBoxList[iBoxID].iStartY = iStartY;
	end
end

function oBoxList_functions.setBoxColor(iBoxID,iColorR,iColorG,iColorB,iColorA)
	if oBoxList[iBoxID] then
		oBoxList[iBoxID].iFillColorR = iColorR;
		oBoxList[iBoxID].iFillColorG = iColorG;
		oBoxList[iBoxID].iFillColorB = iColorB;
		oBoxList[iBoxID].iFillColorA = iColorA;
	end
end

function oBoxList_functions.setBorderColor(iBoxID,iColorR,iColorG,iColorB,iColorA)
	if oBoxList[iBoxID] then
		oBoxList[iBoxID].iBorderColorR = iColorR;
		oBoxList[iBoxID].iBorderColorG = iColorG;
		oBoxList[iBoxID].iBorderColorB = iColorB;
		oBoxList[iBoxID].iBorderColorA = iColorA;
	end
end

function oBoxList_functions.fadeBox(iBoxID,iFillColorR,iFillColorG,iFillColorB,iFillColorA,iBorderColorR,iBorderColorB,iBorderColorG,iBorderColorA,iTime,bIn)
	if not oBoxList[iBoxID] then
		return;
	end
	local iEffectID = 1;
	while (oBoxList_boxesInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	bBoxList_boxesInEffects[iEffectID] = {};
	if bIn then
		bBoxList_boxesInEffects[iEffectID].iEffect = iDEF_FADI;
	else
		bBoxList_boxesInEffects[iEffectID].iEffect = iDEF_FADO;
	end
	bBoxList_boxesInEffects[iEffectID].iBoxID = iBoxID;
	bBoxList_boxesInEffects[iEffectID].iFillColorR = iFillColorR;
	bBoxList_boxesInEffects[iEffectID].iFillColorG = iFillColorG;
	bBoxList_boxesInEffects[iEffectID].iFillColorB = iFillColorB;
	bBoxList_boxesInEffects[iEffectID].iFillColorA = iFillColorA;
	bBoxList_boxesInEffects[iEffectID].iBorderColorR = iBorderColorR;
	bBoxList_boxesInEffects[iEffectID].iBorderColorG = iBorderColorG;
	bBoxList_boxesInEffects[iEffectID].iBorderColorB = iBorderColorB;
	bBoxList_boxesInEffects[iEffectID].iBorderColorA = iBorderColorA;
	bBoxList_boxesInEffects[iEffectID].iBeginTime = getTickCount();
	bBoxList_boxesInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oBoxList_functions.moveBox(iBoxID,iStartX,iStartY,iTime)
	if not oBoxList[iBoxID] then
		return;
	end
	local iEffectID = 1;
	while (oBoxList_boxesInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	bBoxList_boxesInEffects[iEffectID] = {};
	bBoxList_boxesInEffects[iEffectID].iEffect = iDEF_MOVE;
	bBoxList_boxesInEffects[iEffectID].iBoxID = iBoxID;
	bBoxList_boxesInEffects[iEffectID].iStartX = iStartX;
	bBoxList_boxesInEffects[iEffectID].iStartY = iStartY;
	bBoxList_boxesInEffects[iEffectID].iBeginTime = getTickCount();
	bBoxList_boxesInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oBoxList_functions.transformBox(iBoxID,iStartX,iStartY,iWidth,iHeight)
	if not oBoxList[iBoxID] then
		return;
	end
	local iEffectID = 1;
	while (oBoxList_boxesInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	bBoxList_boxesInEffects[iEffectID] = {};
	bBoxList_boxesInEffects[iEffectID].iEffect = iDEF_TRAN;
	bBoxList_boxesInEffects[iEffectID].iBoxID = iBoxID;
	bBoxList_boxesInEffects[iEffectID].iStartX = iStartX;
	bBoxList_boxesInEffects[iEffectID].iStartY = iStartY;
	bBoxList_boxesInEffects[iEffectID].iWidth  = iWidth;
	bBoxList_boxesInEffects[iEffectID].iHeight = iHeight;
	bBoxList_boxesInEffects[iEffectID].iBeginTime = getTickCount();
	bBoxList_boxesInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oBoxList_functions.setBoxTransformation(iBoxID,iStartX,iStartY,iWidth,iHeight)
	if oBoxList[iBoxID] then
		oBoxList[iBoxID].iStartX = iStartX;
		oBoxList[iBoxID].iStartY = iStartY;
		oBoxList[iBoxID].iWidth  = iWidth;
		oBoxList[iBoxID].iHeight = iHeight;
	end
end

function oBoxList_functions.fadeAndDelete(iBoxID,iFillColor,iBorderColor,iTime)
	if oBoxList[iBoxID] then
		oBoxList_fadeBox(iBoxID,iFillColor,iBorderColor,iTime);
		setTimer(oBoxList_functions.delete,iTime,1,iBoxID);
	end
end

function oBoxList_functions.delete(iBoxID)
	oBoxList[iBoxID] = nil;
end

---------------------------------------------
---------------------------------------------
oTextList = {}-- each box contains the following info: iStartX,iStartY,iWidth,iHeight,iFillColor,iBorderColor,iBorderWidth,bActive
oTextList_functions = {};
oTextList_TextInEffects = {};


function oTextList_functions.newText(sText,iStartX,iStartY,iWidth,iHeight,iColorR,iColorG,iColorB,iColorA,sFont,sLeftRightAlign,sTopDownAlign,bActive,bShadow)
	local iTextID;
	iTextID = 1;
	while oTextList[iTextID] do
		iTextID = iTextID + 1;
	end
	oTextList[iTextID] = {};
	oTextList[iTextID].iStartX 		= iStartX;
	oTextList[iTextID].iStartY 		= iStartY;
	oTextList[iTextID].iWidth  		= iWidth;
	oTextList[iTextID].iHeight 		= iHeight;
	oTextList[iTextID].iColorR  		= iColorR;
	oTextList[iTextID].iColorG  		= iColorG;
	oTextList[iTextID].iColorB  		= iColorB;
	oTextList[iTextID].iColorA  		= iColorA;
	oTextList[iTextID].sText   		= sText;
	oTextList[iTextID].sFont   		= sFont;
	oTextList[iTextID].sLeftRightAlign  	= sLeftRightAlign;
	oTextList[iTextID].sTopDownAlign   	= sTopDownAlign;
	oTextList[iTextID].bActive 		= bActive;
	oTextList[iTextID].bShadow 		= bShadow;
	return iTextID;
end

function oTextList_functions.setTextPosition(iTextID,iStartX,iStartY)
	if oTextList[iTextID] then
		oTextList[iTextID].iStartX = iStartX;
		oTextList[iTextID].iStartY = iStartY;
	end
end

function oTextList_functions.setTextColor(iTextID,iColorR,iColorG,iColorB,iColorA)
	if oTextList[iTextID] then
		oTextList[iTextID].iColorR  		= iColorR;
		oTextList[iTextID].iColorG  		= iColorG;
		oTextList[iTextID].iColorB  		= iColorB;
		oTextList[iTextID].iColorA  		= iColorA;
	end
end

function oTextList_functions.setTextShadow(bShadow)
	if oTextList[iTextID] then
		oTextList[iTextID].bShadow 		= bShadow;
	end
end

function oTextList_functions.fadeText(iTextID,iColorR,iColorG,iColorB,iColorA,iTime,bIn)
	if not oTextList[iTextID] then
		return;
	end
	local iEffectID = 1;
	while (oTextList_TextInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oTextList_TextInEffects[iEffectID] = {};
	if bIn then
		oTextList_TextInEffects[iEffectID].iEffect = iDEF_FADI;
	else
		oTextList_TextInEffects[iEffectID].iEffect = iDEF_FADO;
	end
	oTextList_TextInEffects[iEffectID].iTextID 	= iTextID;
	oTextList_TextInEffects[iEffectID].iColorR 	= iColorR;
	oTextList_TextInEffects[iEffectID].iColorG 	= iColorG;
	oTextList_TextInEffects[iEffectID].iColorB 	= iColorB;
	oTextList_TextInEffects[iEffectID].iColorA 	= iColorA;
	oTextList_TextInEffects[iEffectID].iBeginTime 	= getTickCount();
	oTextList_TextInEffects[iEffectID].iEndTime 	= getTickCount() + iTime;
end

function oTextList_functions.moveText(iTextID,iStartX,iStartY,iTime)
	if not oTextList[iTextID] then
		return;
	end
	local iEffectID = 1;
	while (oTextList_TextInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oTextList_TextInEffects[iEffectID] = {};
	oTextList_TextInEffects[iEffectID].iEffect = iDEF_MOVE;
	oTextList_TextInEffects[iEffectID].iTextID = iTextID;
	oTextList_TextInEffects[iEffectID].iStartX = iStartX;
	oTextList_TextInEffects[iEffectID].iStartY = iStartY;
	oTextList_TextInEffects[iEffectID].iBeginTime = getTickCount();
	oTextList_TextInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oTextList_functions.transformText(iTextID,iStartX,iStartY,iWidth,iHeight)
	if not oTextList[iTextID] then
		return;
	end
	local iEffectID = 1;
	while (oTextList_TextInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oTextList_TextInEffects[iEffectID] = {};
	oTextList_TextInEffects[iEffectID].iEffect = iDEF_TRAN;
	oTextList_TextInEffects[iEffectID].iTextID = iTextID;
	oTextList_TextInEffects[iEffectID].iStartX = iStartX;
	oTextList_TextInEffects[iEffectID].iStartY = iStartY;
	oTextList_TextInEffects[iEffectID].iWidth  = iWidth;
	oTextList_TextInEffects[iEffectID].iHeight = iHeight;
	oTextList_TextInEffects[iEffectID].iBeginTime = getTickCount();
	oTextList_TextInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oTextList_functions.setTextTransformation(iTextID,iStartX,iStartY,iWidth,iHeight)
	if oTextList[iTextID] then
		oTextList[iTextID].iStartX = iStartX;
		oTextList[iTextID].iStartY = iStartY;
		oTextList[iTextID].iWidth  = iWidth;
		oTextList[iTextID].iHeight = iHeight;
	end
end

function oTextList_functions.fadeAndDelete(iTextID,iFillColor,iTime)
	if oTextList[iTextID] then
		oText_fadeText(iTextID,iColor,iTime);
		setTimer(oTextList_functions.delete,iTime,1,iTextID);
	end
end

function oTextList_functions.delete(iTextID)
	oTextList[iTextID] = nil;
end

function oTextList_functions.setText(iTextID,sText)
	if oTextList[iTextID] then
		oTextList[iTextID].sText = sText;
	end
end

---------------------------------------------
---------------------------------------------
oImageList = {}-- each box contains the following info: iStartX,iStartY,iWidth,iHeight,iFillColor,iBorderColor,iBorderWidth,bActive
oImageList_functions = {};
oImageList_ImageInEffects = {};


function oImageList_functions.newImage(sImage,iStartX,iStartY,iWidth,iHeight,iColorR,iColorG,iColorB,iColorA,bActive)
	local iImageID;
	iImageID = 1;
	while oImageList[iImageID] do
		iImageID = iImageID + 1;
	end
	oImageList[iImageID] = {};
	oImageList[iImageID].iStartX 		= iStartX;
	oImageList[iImageID].iStartY 		= iStartY;
	oImageList[iImageID].iWidth  		= iWidth;
	oImageList[iImageID].iHeight 		= iHeight;
	oImageList[iImageID].iColorR  		= iColorR;
	oImageList[iImageID].iColorG  		= iColorG;
	oImageList[iImageID].iColorB  		= iColorB;
	oImageList[iImageID].iColorA  		= iColorA;
	oImageList[iImageID].sImage   		= sImage;
	oImageList[iImageID].bActive 		= bActive;
	return iImageID;
end

function oImageList_functions.setImagePosition(iImageID,iStartX,iStartY)
	if oImageList[iImageID] then
		oImageList[iImageID].iStartX = iStartX;
		oImageList[iImageID].iStartY = iStartY;
	end
end

function oImageList_functions.setImageColor(iImageID,iColorR,iColorG,iColorB,iColorA)
	if oImageList[iImageID] then
		oImageList[iImageID].iColorR  		= iColorR;
		oImageList[iImageID].iColorG  		= iColorG;
		oImageList[iImageID].iColorB  		= iColorB;
		oImageList[iImageID].iColorA  		= iColorA;
	end
end

function oImageList_functions.fadeImage(iImageID,iColorR,iColorG,iColorB,iColorA,iTime,bIn)
	if not oImageList[iImageID] then
		return;
	end
	local iEffectID = 1;
	while (oImageList_ImageInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oImageList_ImageInEffects[iEffectID] = {};
	if bIn then
		oImageList_ImageInEffects[iEffectID].iEffect = iDEF_FADI;
	else
		oImageList_ImageInEffects[iEffectID].iEffect = iDEF_FADO;
	end
	oImageList_ImageInEffects[iEffectID].iImageID 	= iImageID;
	oImageList_ImageInEffects[iEffectID].iColorR 	= iColorR;
	oImageList_ImageInEffects[iEffectID].iColorG 	= iColorG;
	oImageList_ImageInEffects[iEffectID].iColorB 	= iColorB;
	oImageList_ImageInEffects[iEffectID].iColorA 	= iColorA;
	oImageList_ImageInEffects[iEffectID].iBeginTime 	= getTickCount();
	oImageList_ImageInEffects[iEffectID].iEndTime 	= getTickCount() + iTime;
end

function oImageList_functions.moveImage(iImageID,iStartX,iStartY,iTime)
	if not oImageList[iImageID] then
		return;
	end
	local iEffectID = 1;
	while (oImageList_ImageInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oImageList_ImageInEffects[iEffectID] = {};
	oImageList_ImageInEffects[iEffectID].iEffect = iDEF_MOVE;
	oImageList_ImageInEffects[iEffectID].iImageID = iImageID;
	oImageList_ImageInEffects[iEffectID].iStartX = iStartX;
	oImageList_ImageInEffects[iEffectID].iStartY = iStartY;
	oImageList_ImageInEffects[iEffectID].iBeginTime = getTickCount();
	oImageList_ImageInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oImageList_functions.transformImage(iImageID,iStartX,iStartY,iWidth,iHeight)
	if not oImageList[iImageID] then
		return;
	end
	local iEffectID = 1;
	while (oImageList_ImageInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oImageList_ImageInEffects[iEffectID] = {};
	oImageList_ImageInEffects[iEffectID].iEffect = iDEF_TRAN;
	oImageList_ImageInEffects[iEffectID].iImageID = iImageID;
	oImageList_ImageInEffects[iEffectID].iStartX = iStartX;
	oImageList_ImageInEffects[iEffectID].iStartY = iStartY;
	oImageList_ImageInEffects[iEffectID].iWidth  = iWidth;
	oImageList_ImageInEffects[iEffectID].iHeight = iHeight;
	oImageList_ImageInEffects[iEffectID].iBeginTime = getTickCount();
	oImageList_ImageInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oImageList_functions.setImageTransformation(iImageID,iStartX,iStartY,iWidth,iHeight)
	if oImageList[iImageID] then
		oImageList[iImageID].iStartX = iStartX;
		oImageList[iImageID].iStartY = iStartY;
		oImageList[iImageID].iWidth  = iWidth;
		oImageList[iImageID].iHeight = iHeight;
	end
end

function oImageList_functions.fadeAndDelete(iImageID,iFillColor,iTime)
	if oImageList[iImageID] then
		oImage_fadeImage(iImageID,iColor,iTime);
		setTimer(oImageList_functions.delete,iTime,1,iImageID);
	end
end

function oImageList_functions.delete(iImageID)
	oImageList[iImageID] = nil;
end

function oImageList_functions.setImage(iImageID,sImage)
	if oImageList[iImageID] then
		oImageList[iImageID].sImage = sImage;
	end
end
---------------------------------------------
---------------------------------------------
oArrayList = {}-- each box contains the following info: iStartX,iStartY,iWidth,iHeight,iFillColor,iBorderColor,iBorderWidth,bActive
oArrayList_functions = {};
oArrayList_ArrayInEffects = {};

--dxDrawArray(aArray,iStartX,iStartY,iWidth,iHeight,sFont,iColor);
--dxDrawArray(aArray,iStartX,iStartY,iEndX,iEndY,sFont,iColor)
function oArrayList_functions.newArray(aArray,iStartX,iStartY,iWidth,iHeight,iColorR,iColorG,iColorB,iColorA,sFont,sLeftRightAlign,sTopDownAlign,bActive)
	local iArrayID;
	iArrayID = 1;
	while oArrayList[iArrayID] do
		iArrayID = iArrayID + 1;
	end
	oArrayList[iArrayID] = {};
	oArrayList[iArrayID].iStartX 		= iStartX;
	oArrayList[iArrayID].iStartY 		= iStartY;
	oArrayList[iArrayID].iWidth  		= iWidth;
	oArrayList[iArrayID].iHeight 		= iHeight;
	oArrayList[iArrayID].iColorR  		= iColorR;
	oArrayList[iArrayID].iColorG  		= iColorG;
	oArrayList[iArrayID].iColorB  		= iColorB;
	oArrayList[iArrayID].iColorA  		= iColorA;
	oArrayList[iArrayID].aArray   		= aArray;
	oArrayList[iArrayID].sFont   		= sFont;
	oArrayList[iArrayID].sLeftRightAlign  	= sLeftRightAlign;
	oArrayList[iArrayID].sTopDownAlign   	= sTopDownAlign;
	oArrayList[iArrayID].bActive 		= bActive;
end

function oArrayList_functions.setArrayPosition(iArrayID,iStartX,iStartY)
	if oArrayList[iArrayID] then
		oArrayList[iArrayID].iStartX = iStartX;
		oArrayList[iArrayID].iStartY = iStartY;
	end
end

function oArrayList_functions.setArrayColor(iArrayID,iColorR,iColorG,iColorB,iColorA)
	if oArrayList[iArrayID] then
		oArrayList[iArrayID].iColorR  		= iColorR;
		oArrayList[iArrayID].iColorG  		= iColorG;
		oArrayList[iArrayID].iColorB  		= iColorB;
		oArrayList[iArrayID].iColorA  		= iColorA;
	end
end

function oArrayList_functions.fadeArray(iArrayID,iColorR,iColorG,iColorB,iColorA,iTime,bIn)
	if not oArrayList[iArrayID] then
		return;
	end
	local iEffectID = 1;
	while (oArrayList_ArrayInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oArrayList_ArrayInEffects[iEffectID] = {};
	if bIn then
		oArrayList_ArrayInEffects[iEffectID].iEffect = iDEF_FADI;
	else
		oArrayList_ArrayInEffects[iEffectID].iEffect = iDEF_FADO;
	end
	oArrayList_ArrayInEffects[iEffectID].iArrayID 	= iArrayID;
	oArrayList_ArrayInEffects[iEffectID].iColorR 	= iColorR;
	oArrayList_ArrayInEffects[iEffectID].iColorG 	= iColorG;
	oArrayList_ArrayInEffects[iEffectID].iColorB 	= iColorB;
	oArrayList_ArrayInEffects[iEffectID].iColorA 	= iColorA;
	oArrayList_ArrayInEffects[iEffectID].iBeginTime 	= getTickCount();
	oArrayList_ArrayInEffects[iEffectID].iEndTime 	= getTickCount() + iTime;
end

function oArrayList_functions.moveArray(iArrayID,iStartX,iStartY,iTime)
	if not oArrayList[iArrayID] then
		return;
	end
	local iEffectID = 1;
	while (oArrayList_ArrayInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oArrayList_ArrayInEffects[iEffectID] = {};
	oArrayList_ArrayInEffects[iEffectID].iEffect = iDEF_MOVE;
	oArrayList_ArrayInEffects[iEffectID].iArrayID = iArrayID;
	oArrayList_ArrayInEffects[iEffectID].iStartX = iStartX;
	oArrayList_ArrayInEffects[iEffectID].iStartY = iStartY;
	oArrayList_ArrayInEffects[iEffectID].iBeginTime = getTickCount();
	oArrayList_ArrayInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oArrayList_functions.transformArray(iArrayID,iStartX,iStartY,iWidth,iHeight)
	if not oArrayList[iArrayID] then
		return;
	end
	local iEffectID = 1;
	while (oArrayList_ArrayInEffects[iEffectID]) do
		iEffectID = iEffectID + 1;
	end
	oArrayList_ArrayInEffects[iEffectID] = {};
	oArrayList_ArrayInEffects[iEffectID].iEffect = iDEF_TRAN;
	oArrayList_ArrayInEffects[iEffectID].iArrayID = iArrayID;
	oArrayList_ArrayInEffects[iEffectID].iStartX = iStartX;
	oArrayList_ArrayInEffects[iEffectID].iStartY = iStartY;
	oArrayList_ArrayInEffects[iEffectID].iWidth  = iWidth;
	oArrayList_ArrayInEffects[iEffectID].iHeight = iHeight;
	oArrayList_ArrayInEffects[iEffectID].iBeginTime = getTickCount();
	oArrayList_ArrayInEffects[iEffectID].iEndTime = getTickCount() + iTime;
end

function oArrayList_functions.setArrayTransformation(iArrayID,iStartX,iStartY,iWidth,iHeight)
	if oArrayList[iArrayID] then
		oArrayList[iArrayID].iStartX = iStartX;
		oArrayList[iArrayID].iStartY = iStartY;
		oArrayList[iArrayID].iWidth  = iWidth;
		oArrayList[iArrayID].iHeight = iHeight;
	end
end

function oArrayList_functions.fadeAndDelete(iArrayID,iFillColor,iTime)
	if oArrayList[iArrayID] then
		oArray_fadeArray(iArrayID,iColor,iTime);
		setTimer(oArrayList_functions.delete,iTime,1,iArrayID);
	end
end

function oArrayList_functions.delete(iArrayID)
	oArrayList[iArrayID] = nil;
end

function oArrayList_functions.setArray(iArrayID,aArray)
	if oArrayList[iArrayID] then
		oArrayList[iArrayID].aArray = aArray;
	end
end

---------------------------------------------
---------------------------------------------

function dxDrawBoxCenter(iCenterX,iCenterY,iWidth,iHeight,cFillColor,cBorderColor,fBorderWidth,bIsFilled)
	local iStartX = iCenterX - iWidth/2;
	local iStartY = iCenterY - iHeight/2;
	dxDrawBox(iStartX,iStartY,iWidth,iHeight,bFill,bBorder,cFillColor,cBorderColor,fBorderWidth,bIsFilled)
end


function dxDrawBox(iStartX,iStartY,iWidth,iHeight,cFillColor,cBorderColor,fBorderWidth,bIsFilled)
	if bIsFilled then
		dxDrawRectangle(iStartX,iStartY,iWidth,iHeight,cFillColor,true); -- headline
	end
	if fBorderWidth > 0 then
		iTRCornerX = iStartX			+fBorderWidth/2;
		iTRCornerY = iStartY			+fBorderWidth/2;

		iTLCornerX = iStartX+iWidth		-fBorderWidth/2;
		iTLCornerY = iStartY			+fBorderWidth/2;

		iBLCornerX = iStartX+iWidth		-fBorderWidth/2;
		iBLCornerY = iStartY+iHeight		-fBorderWidth/2;

		iBRCornerX = iStartX			+fBorderWidth/2;
		iBRCornerY = iStartY+iHeight		-fBorderWidth/2;

		dxDrawLine ( iTRCornerX, iTRCornerY, iTLCornerX, iTLCornerY, cBorderColor, fBorderWidth, true )
		dxDrawLine ( iTLCornerX, iTLCornerY, iBLCornerX, iBLCornerY, cBorderColor, fBorderWidth, true )
		dxDrawLine ( iBLCornerX, iBLCornerY, iBRCornerX, iBRCornerY, cBorderColor, fBorderWidth, true )
		dxDrawLine ( iBRCornerX, iBRCornerY, iTRCornerX, iTRCornerY, cBorderColor, fBorderWidth, true )
	end
end

function dxDrawArrayCenter(aArray,iCenterX,iCenterY,iWidth,iHeight)
	local iStartX = iCenterX - iWidth/2;
	local iStartY = iCenterY - iHeight/2;
	dxDrawArray(aArray,iStartX,iStartY,iWidth + iStartX,iHeight + iStartY)
end

function dxDrawArray(aArray,iStartX,iStartY,iEndX,iEndY,sFont,iColor,sUpDownAlign,sLeftRightAlign)
	local iArrayCount = #aArray;
	if iArrayCount == 0 then
		return;
	end
	if iArrayCount > 10 then
		return;
	end
	local iArrayTextHeight = (iEndY - iStartY)/iArrayCount;
	iCounter = 0;
	for vVar,elm in pairs(aArray) do
		dxDrawText ( 	tostring(elm),
				iStartX, 
				iStartY + iCounter*iArrayTextHeight, 
				iEndX, 
				iStartY + (iCounter+1)*iArrayTextHeight,
				iColor,
				iArrayTextHeight/35,
				sFont,
				sLeftRightAlign,
				sUpDownAlign,
				true,
				true,
				true
				);
		iCounter = iCounter + 1;
		if iCounter > 10 then
			return;
		end
	end
end
 
function _SHOWMENU_renderanimation()
	--oBoxList_boxesInEffects
	--oTextList_TextInEffects
	--oArrayList_ArrayInEffects
end

function _SHOWMENU_rendermenu()
	--rendering things systematically: from up to down.
	if bRender then
		_SHOWMENU_renderanimation()
		--boxes go first
		for i,elm in ipairs(oBoxList) do
			if elm.bActive then
				local iStartX = elm.iStartX;
				local iStartY = elm.iStartY;
				local iWidth  = elm.iWidth;
				local iHeight = elm.iHeight;
				local iFillColor = tocolor(elm.iFillColorR,elm.iFillColorG,elm.iFillColorB,elm.iFillColorA);
				local iBorderColor = tocolor(elm.iBorderColorR, elm.iBorderColorG, elm.iBorderColorB, elm.iBorderColorA);
				local iBorderWidth = elm.iBorderWidth;
				dxDrawBox(iStartX,iStartY,iWidth,iHeight,iFillColor,iBorderColor,iBorderWidth,true);
			end
		end
		for i,elm in ipairs(oImageList) do
			if elm.bActive then
				local iStartX = elm.iStartX;
				local iStartY = elm.iStartY;
				local sImage   = elm.sImage;
				local iWidth  = elm.iWidth;
				local iHeight = elm.iHeight;
				local iColor  = tocolor(elm.iColorR,elm.iColorG,elm.iColorB,elm.iColorA);
				dxDrawImage ( 	iStartX,
						iStartY,
						iWidth,
						iHeight,
						sImage,
						0,
						0,
						0,
						iColor,
						true );
			end
		end
		for i,elm in ipairs(oTextList) do
			if elm.bActive then
				local iStartX = elm.iStartX;
				local iStartY = elm.iStartY;
				local sText   = elm.sText;
				local iWidth  = elm.iWidth;
				local iHeight = elm.iHeight;
				local iColor  = tocolor(elm.iColorR,elm.iColorG,elm.iColorB,elm.iColorA);
				local sFont   = elm.sFont;
				local sTopDownAlign = elm.sTopDownAlign
				local sLeftRightAlign = elm.sLeftRightAlign
				if elm.bShadow then
					dxDrawText ( 	sText,
							iStartX+2,
							iStartY+2,
							iStartX + iWidth+2,
							iStartY + iHeight+2,
							tocolor(255-elm.iColorR,255-elm.iColorG,255-elm.iColorB,elm.iColorA),
							iHeight/27,
							sFont,
							sLeftRightAlign,
							sTopDownAlign,
							true,
							true,
							true );
				end
				dxDrawText ( 	sText,
						iStartX,
						iStartY,
						iStartX + iWidth,
						iStartY + iHeight,
						iColor,
						iHeight/27,
						sFont,
						sLeftRightAlign,
						sTopDownAlign,
						true,
						true,
						true );
			end
		end
		for i,elm in ipairs(oArrayList) do
			if elm.bActive then
				local iStartX = elm.iStartX;
				local iStartY = elm.iStartY;
				local aArray  = elm.aArray;
				local iWidth  = elm.iWidth;
				local iHeight = elm.iHeight;
				local iColor  = tocolor(elm.iColorR,elm.iColorG,elm.iColorB,elm.iColorA);
				local sFont   = elm.sFont;
				local sTopDownAlign = elm.sTopDownAlign
				local sLeftRightAlign = elm.sLeftRightAlign
				dxDrawArray(aArray,
						iStartX,
						iStartY,
						iWidth+iStartX,
						iHeight+iStartY,
						sFont,
						iColor,
						sTopDownAlign,
						sLeftRightAlign);
			end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),_SHOWMENU_rendermenu);
