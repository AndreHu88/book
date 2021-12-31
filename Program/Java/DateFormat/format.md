## java日期中YYYY与yyyy的区别
### 示例代码
```
    public static void main(String[] args) {
    	Date date =new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
    	String date1 = sdf.format(date);
    	System.out.println("YYYY-MM-dd HH:mm:ss="+date1);
    	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	sdf1.format(date);
    	String date2 = sdf1.format(date);
    	System.out.println("yyyy-MM-dd HH:mm:ss="+date2);
	}
```
### 运行结果
```
YYYY-MM-dd HH:mm:ss=2022-12-31 17:35:01
yyyy-MM-dd HH:mm:ss=2021-12-31 17:35:01
```
### 结论
```
YYYY是表示：当天所在的周属于的年份，一周从周日开始，周六结束，只要本周跨年，那么这周就算入下一年
yyyy是表示：当前年份
JDk6 SimpleDateFormat 只有只有小写 ‘y’，JDK7后引入大写 ‘Y’表示week year
```