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

            ms.mimeType && (imageList.push(item.path + item.filename))
        });
        return imageList;

    }
};
//获取文件夹下的所有图片
var list = getFiles.getImageFiles("../../../cocosstudio/cocosstudio/");
var md5Table = {}
var md5Count = 0;
list.forEach(function (filename) {
    // console.log(filename)

    var rs = fs.createReadStream(filename);
    var hash = crypto.createHash('md5');
    rs.on('data', hash.update.bind(hash));
    rs.on('end', function () {
        md5Table[filename] = hash.digest('hex');
        md5Count ++;
        if (md5Count >= list.length) {
            console.log("完了");
            // md5重复table
            var md5RepeatTable = {};
            list.forEach((item)=>{
                // console.log(item, md5Table[item]);
                var md5Value = md5Table[item];
                if(!md5RepeatTable[md5Value]){
                    md5RepeatTable[md5Value] = [];
                }
                md5RepeatTable[md5Value].push(item);
            });
            for (var md5Value in md5RepeatTable) {
                if (md5RepeatTable[md5Value].length > 1) {
                    console.log("重复md5", md5Value);
                    md5RepeatTable[md5Value].forEach((item)=>{
                        console.log(item);
                    });
                    console.log("");
                }
            }
        }
    });
});


