package com.frontend.utils;

import java.sql.*;
import java.util.ArrayList;
import com.frontend.domain.MCPacket;

import com.frontend.models.*;

public class DBHelper {
	public static final DBHelper instance = new DBHelper();
	public String sslport;

	String username;
	String password;

	static Connection getConnection() {

		try {
			DBConfig config = new DBConfig();
			// 加载驱动程序
			Class.forName(config.getDriver());

			// 连续数据库
			Connection conn = (Connection) DriverManager.getConnection(config.getUrl());
			return conn;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static ArrayList<MCPacket> getPackageListByUID(int uid, boolean show) {
		Connection conn = getConnection();
		ArrayList<MCPacket> list = new ArrayList<MCPacket>();
		try {
			if (!conn.isClosed()) {

				// statement用来执行SQL语句
				Statement statement = (Statement) conn.createStatement();

				// 要执行的SQL语句
				String sql = "select * from Packet WHERE order by build DESC";

				// 结果集
				ResultSet rs = statement.executeQuery(sql);

				while (rs.next()) {
					MCPacket package1 = new MCPacket();
					package1.setId(rs.getInt("id"));
					package1.setTitle(rs.getString("title"));
					if (show) {
						package1.setComment(rs.getString("content").replaceAll("\n", "<br/>"));
					}else {
						package1.setComment(rs.getString("content"));
					}
					package1.setVersion(rs.getString("version"));
					package1.setBuild(rs.getInt("build"));
					package1.setTime(rs.getTimestamp("updateDate"));
					package1.setFileLength(rs.getLong("fileLength"));
					list.add(package1);
				}

				rs.close();
				conn.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return list;
	}

	public static boolean updateFile(int id,String version,long length) {
		Connection conn = getConnection();
		try {
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");

			// statement用来执行SQL语句
			Statement statement = (Statement) conn.createStatement();

			// 要执行的SQL语句
			String sql = "UPDATE packages SET updateDate = NOW(),upload=1,version='"+version+"',fileLength="+length+" where id=" + id;

			// 结果集
			int ret = statement.executeUpdate(sql);

			conn.close();
			return ret > 0;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}

	public static boolean updatePackage(MCPacket package1) {
		// TODO Auto-generated method stub
		Connection conn = getConnection();
		try {
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");

			// statement用来执行SQL语句
			Statement statement = (Statement) conn.createStatement();

			// 要执行的SQL语句
			int ret;
			if (package1.getId() == 0) {
				String sql = "insert packages(uid,title,content,updateDate) values(" + package1.getId() + ",'"
						+ package1.getTitle() + "','" + package1.getComment() + "',NOW())";

				// 结果集
				ret = statement.executeUpdate(sql);
				ResultSet rSet = statement.executeQuery("select LAST_INSERT_ID() rowid");
				while (rSet.next()) {
					package1.setId(rSet.getInt("rowid"));
				}
				rSet.close();
			} else {
				String sql = "UPDATE packages SET title='" + package1.getTitle() + "',content='" + package1.getComment()
						+ "',updateDate = NOW() where id=" + package1.getId();
				ret = statement.executeUpdate(sql);
			}

			conn.close();
			return ret > 0;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}

	public static boolean deletePackage(int pid) {
		// TODO Auto-generated method stub
				Connection conn = getConnection();
				try {
					if (!conn.isClosed())
						System.out.println("Succeeded connecting to the Database!");

					// statement用来执行SQL语句
					Statement statement = (Statement) conn.createStatement();

					// 要执行的SQL语句
					String sql = "delete from packages where id=" + pid;

						// 结果集
					int ret = statement.executeUpdate(sql);

					conn.close();
					return ret > 0;

				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return false;
	}

	public static MCPacket getPackageListByUID(String string) {
		Connection conn = getConnection();
		ArrayList<MCPacket> list = new ArrayList<MCPacket>();
		try {
			if (!conn.isClosed()) {

				// statement用来执行SQL语句
				Statement statement = (Statement) conn.createStatement();

				// 要执行的SQL语句
				String sql = "select * from packages WHERE id=" + string + " order by updateDate DESC";

				// 结果集
				ResultSet rs = statement.executeQuery(sql);

				while (rs.next()) {
					MCPacket package1 = new MCPacket();
					package1.setId(rs.getInt("id"));
					package1.setTitle(rs.getString("title"));
					package1.setComment(rs.getString("content"));
					package1.setVersion(rs.getString("version"));
					package1.setUpdateDate(rs.getTimestamp("updateDate"));
					package1.setFileLength(rs.getLong("fileLength"));
					return package1;
				}

				rs.close();
				conn.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	public static boolean regDBDevice(String deviceId,String ip) {
		// TODO Auto-generated method stub
		Connection conn = getConnection();
		try {
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");

			// statement用来执行SQL语句
			Statement statement = (Statement) conn.createStatement();

			// 要执行的SQL语句
			String sql = "INSERT INTO client(deviceid,ipaddr,updateTime,status) VALUES('" + deviceId + "','" + ip + "', datetime(), 1)";
			int ret = statement.executeUpdate(sql);

			conn.close();
			return ret > 0;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
}
