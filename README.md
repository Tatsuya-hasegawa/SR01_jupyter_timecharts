# SR01_jupyter_timecharts

SR分科会１回目のハンズオン課題に対するJupyter notebook上での(Julia,Python,R)言語らの解答レポジトリです。
それぞれVSCode上でJupyter notebookファイル内で実行処理しています。

対象データは [Phishing URL dataset from JPCERT/CC](https://github.com/JPCERTCC/phishurl-list)の2022年4月から2023年3月までの１年分のデータです。

対象データの前処理

```
git clone https://github.com/JPCERTCC/phishurl-list.git
cd phishurllist
cat 2022/202204.csv 2022/202205.csv 2022/202206.csv 2022/202207.csv 2022/202208.csv 2022/202209.csv 2022/202210.csv 2022/202211.csv 2022/202212.csv 2023/202301.csv 2023/202302.csv 2023/202303.csv > merged_202204-202303_noduplabel.csv
```

hackeT
