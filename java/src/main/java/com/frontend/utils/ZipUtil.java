package com.frontend.utils;

import java.io.*;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import com.dd.plist.*;


/**
 * 通过Java的Zip输入输出流实现压缩和解压文件
 */
public final class ZipUtil {

    private ZipUtil() {

    }

    /**
     * 解压IPA文件，只获取IPA文件的Info.plist文件存储指定位置
     * @param file   zip文件
     * @param unzipDirectory     解压到的目录
     * @throws Exception
     */
    private static File getZipInfo(File file, String unzipDirectory) throws Exception{
        // 定义输入输出流对象
        InputStream input = null;
        OutputStream output = null;
        File result = null;
        File unzipFile = null;
        ZipFile zipFile = null;
        try{
            // 创建zip文件对象
            zipFile = new ZipFile(file);
            // 创建本zip文件解压目录
            String name = file.getName().substring(0, file.getName().lastIndexOf("."));
            unzipFile = new File(unzipDirectory + "/" + name);
            if(unzipFile.exists()){
                unzipFile.delete();
            }
            unzipFile.mkdir();
            // 得到zip文件条目枚举对象
            Enumeration<? extends ZipEntry> zipEnum = zipFile.entries();
            // 定义对象
            ZipEntry entry = null;
            String entryName = null;
            String names[] = null;
            int length;
            // 循环读取条目
            while(zipEnum.hasMoreElements()){
                // 得到当前条目
                entry = zipEnum.nextElement();
                entryName = new String(entry.getName());
                // 用/分隔条目名称
                names = entryName.split("\\/");
                length = names.length;
                for(int v = 0; v < length; v++){
                    if(entryName.endsWith(".app/Info.plist")){ // 为Info.plist文件,则输出到文件
                        input = zipFile.getInputStream(entry);
                        result = new File(unzipFile.getAbsolutePath() + "/Info.plist");
                        output = new FileOutputStream(result);
                        byte[] buffer = new byte[1024 * 8];
                        int readLen = 0;
                        while((readLen = input.read(buffer, 0, 1024 * 8)) != -1){
                            output.write(buffer, 0, readLen);
                        }
                        break;
                    }
                }
            }
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
        finally{
            if(input != null){
                input.close();
            }
            if(output != null){
                output.flush();
                output.close();
            }
            // 必须关流，否则文件无法删除
            if(zipFile != null){
                zipFile.close();
            }
        }

        // 如果有必要删除多余的文件
        if(file.exists()){
            file.delete();
        }
        return result;
    }

    /**
     * IPA文件的拷贝，把一个IPA文件复制为Zip文件,同时返回Info.plist文件 参数 oldfile 为 IPA文件
     */
    private static File getIpaInfo(File oldfile) throws IOException{
        try{
            int byteread = 0;
            String filename = oldfile.getAbsolutePath().replaceAll(".ipa", ".zip");
            File newfile = new File(filename);
            if(oldfile.exists()){
                // 创建一个Zip文件
                InputStream inStream = new FileInputStream(oldfile);
                FileOutputStream fs = new FileOutputStream(newfile);
                byte[] buffer = new byte[1444];
                while((byteread = inStream.read(buffer)) != -1){
                    fs.write(buffer, 0, byteread);
                }
                if(inStream != null){
                    inStream.close();
                }
                if(fs != null){
                    fs.close();
                }
                // 解析Zip文件
                return getZipInfo(newfile, newfile.getParent());
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 通过IPA文件获取Info信息
     */
    public static Map<String, String> getVersionInfo(File ipa) throws Exception{

        File file = getIpaInfo(ipa);
    Map<String,String> map = new HashMap<String,String>();
    // 需要第三方jar包dd-plist
    NSDictionary rootDict = (NSDictionary)PropertyListParser.parse(file);

    map.put("CFBundleShortVersionString", rootDict.get("CFBundleShortVersionString").toString());
    map.put("MinimumOSVersion", rootDict.get("MinimumOSVersion").toString());

    // 如果有必要，应该删除解压的结果文件
    file.delete();
    file.getParentFile().delete();

    return map;
    }

    public static void main(String[] args) {
		try {
			Map<String, String> ipaInfo = ZipUtil.getVersionInfo(new File("/Users/bonana/Desktop/Weibo1.9.3.ipa"));

			System.out.println(ipaInfo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
