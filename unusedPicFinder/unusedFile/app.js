//获取项目工程里的图片
var fs = require('fs');//引用文件系统模块
var image = require("imageinfo"); //引用imageinfo模块
var crypto = require('crypto');

function readFileList(path, filesList) {
    var files = fs.readdirSync(path);
    files.forEach(function (itm, index) {
        var stat = fs.statSync(path + itm);
        if (stat.isDirectory()) {
        //递归读取文件
            readFileList(path + itm + "/", filesList)
        } else {

            var obj = {};//定义一个对象存放文件的路径和名字
            obj.path = path;//路径
            obj.filename = itm//名字
            filesList.push(obj);
        }

    })

}
var getFiles = {
    //获取文件夹下的所有文件
    getFileList: function (path) {
        var filesList = [];
        readFileList(path, filesList);
        return filesList;
    },
    //获取文件夹下的所有图片
    getImageFiles: function (path) {
        var imageList = [];

        this.getFileList(path).forEach((item) => {
            var ms = image(fs.readFileSync(item.path + item.filename));

            ms.mimeType && (imageList.push(item))
        });
        return imageList;

    }
};
var ignoreRole = [
    "spine/",
    "ccs/animation/",
    "ccs/batPic/",
    "ccs/font/",
    "ccs/particle/",
    "ccs/tankPic/",
    "ccs/battlePic/battleSkillFire/",
    "ccs/battlePic/battleSkillOther/",
    "ccs/battlePic/beFired",
    "ccs/battlePic/bullet/",
    "ccs/battlePic/countDownLoadBullet/",
    "ccs/battlePic/dead/",
    "ccs/battlePic/fire/",
    "ccs/battlePic/headskill/",
    "ccs/battlePic/tankBreak/",
    "ccs/bigPic/officer_body/",
    "ccs/bigPic/tank_mall/",
    "ccs/uiPic/unlockTroop/troopunlock_trooptext",
    "ccs/uiPic/unlockTroop/troopunlock_trooptitle",
    "ccs/uiPic/unlockTank/qpmb_",
    "ccs/uiPic/unlockTank/hpmb_",
    "ccs/uiPic/unlockTank/ani",
    "ccs/uiPic/battleBuff/",
    "ccs/uiPic/tank/tank_skill_name",
    "ccs/uiPic/tank/quality_",
    "ccs/uiPic/shop/qualitySmallBg",
    "ccs/uiPic/recharge/rechargeDiamond",
    "ccs/uiPic/mapStatus/tj_hrg",
    "ccs/uiPic/mapBottom/mbm_",
    "ccs/uiPic/mapBottom/opt_",
    "ccs/uiPic/comm_quality/",
    "ccs/uiPic/chat/chat_alliancePosIcon",
    "ccs/uiPic/comm_ui/comUnlockIcon",
    "ccs/uiPic/comm_icon/officerArmy",
    "ccs/uiPic/comm_icon/tileOptBtn_",
    "ccs/uiPic/troopConfig/troopNumIcon",
    "ccs/uiPic/lead/createUserPerson_",
    "ccs/battlePic/battleSkillHead/jnyj_",
    "ccs/battlePic/macroBefire/",
    "ccs/battlePic/macroFire/",
    "ccs/battlePic/tankBreakNew/",
    "ccs/battlePic/tankSmoke/qzd_",
    "ccs/bigPic/attackcity/attackcityImage",
    "ccs/bigPic/user_body/user_body",
    "ccs/uiPic/building/buildingUP",
    "ccs/uiPic/building/building_",
    "ccs/uiPic/cityBuild/cityBuild",
    "ccs/uiPic/cityBuild/jianzao_",
    "ccs/uiPic/cityBuild/wancheng_",
    "ccs/uiPic/levelreward/functionicon_",
    "ccs/uiPic/levelreward/functionicontext_",
    "ccs/uiPic/mapStatus/tileLevel_",
    "ccs/uiPic/mapStatus/tileLvIcon_",
    "ccs/uiPic/mapTop/huodong_",
    "ccs/uiPic/mapTop/renwutiao",
    "ccs/battlePic/battleMacroOpenHead/zdks_jltx",
    "ccs/battlePic/macroBefire",
    "ccs/battlePic/macroBullet",
    "ccs/battlePic/tankMacroTrace/zdks_cy",
    "ccs/battlePic/tankSmoke/zdks_yw",
    "ccs/bigPic/officerBg/qualityOfficerBg",
    "ccs/uiPic/firstcharge/firstchargenum_",
    "ccs/uiPic/firstcharge/firstchargeofficer_",
    "ccs/uiPic/mapStatus/circle_",
    "ccs/uiPic/mapStatus/garrison_mark",
    "ccs/uiPic/mapStatus/monsterIcon_",
    "ccs/uiPic/mapTop/active_",
    "ccs/uiPic/mapTop/function_",
    "ccs/uiPic/mapTop/onlinereward_",
    "ccs/uiPic/officerRecruit/nameBg_",
    "ccs/uiPic/officerRecruitB/card",
    "ccs/uiPic/rank/rankImgNum",
    "ccs/uiPic/rank/rank_firstTwoThree",
    "ccs/uiPic/troopConfig/troopCanConfig_",
    "ccs/uiPic/battleMacro/open_head_bg",
    "ccs/uiPic/chat/chat_",
    "ccs/uiPic/comm_ui/comUnlockText",
    "ccs/uiPic/gamePlay/gamePlaybg_",
]
// 依赖关系
var relationTable = {};
// 文件内容
var fileContents = {};

//src
var listLua = getFiles.getFileList("../../../src/");
//csd
var listCsd = getFiles.getFileList("../../../cocosstudio/cocosstudio/ccs/views/");
// src和csd
var listLuaAndCsd = listLua.concat(listCsd);
//图片
var listPic = getFiles.getImageFiles("../../../cocosstudio/cocosstudio/");
// 记录文件内容
listLuaAndCsd.forEach((item)=>{
    fileContents[item.path + item.filename] = fs.readFileSync(item.path + item.filename,"utf-8");
});
// 查找出现次数
listPic.forEach((item)=>{
    var ignore = false;
    ignoreRole.forEach((role)=>{
        var exc = new RegExp(role);
        if(exc.test(item.path + item.filename)) {
            // 被忽略了
            ignore = true;
        }
    });
    if (!ignore){
        relationTable[item.path + item.filename] = [];
        var findStr = item.filename.split(".")[0];
        // var findStr = item.filename;
        var exc = new RegExp(findStr);

        for (var key in fileContents) {
            if(exc.test(fileContents[key])){
                relationTable[item.path + item.filename].push(key);
            }
        }
    }
});
for (var key in relationTable) {
    if (relationTable[key].length < 1){
        console.log(key);
    }
}







