# Olist E-Commerce Data Warehouse & BI Dashboard

## Deskripsi Proyek

Proyek ini merupakan implementasi Data Engineering dan Business Intelligence menggunakan dataset Brazilian E-Commerce Public Dataset by Olist.

Proyek mencakup proses pengolahan data mentah menggunakan Pentaho Data Integration (PDI), pembangunan Data Warehouse menggunakan MySQL, proses ETL, validasi kualitas data, serta pembuatan dashboard analitik menggunakan Microsoft Power BI.

Alur utama proyek:

    Dataset Olist
    ↓
    Pentaho Data Integration
    ↓
    MySQL Data Warehouse
    ↓
    Star Schema
    ↓
    Power BI Dashboard

## Tujuan Proyek

Proyek ini bertujuan untuk:

- Membangun proses ETL dari data mentah ke Data Warehouse.
- Menerapkan konsep Data Warehouse menggunakan Star Schema.
- Mengintegrasikan beberapa dataset Olist menjadi tabel fakta dan tabel dimensi.
- Melakukan validasi kualitas data hasil proses ETL.
- Menghasilkan metrik penjualan, pesanan, pengiriman, pelanggan, produk, dan seller.
- Membuat dashboard interaktif menggunakan Power BI.
- Menyajikan informasi yang dapat digunakan untuk analisis bisnis.

## Teknologi yang Digunakan

- Pentaho Data Integration (PDI) 9.4
- MySQL / MariaDB
- Microsoft Power BI Desktop
- SQL
- Git & GitHub

## Sumber Data

Dataset yang digunakan adalah:

**Brazilian E-Commerce Public Dataset by Olist**

Dataset berisi data transaksi e-commerce seperti:

- Pesanan
- Pelanggan
- Produk
- Seller
- Harga produk
- Biaya pengiriman
- Status pesanan
- Tanggal pemesanan
- Tanggal pengiriman
- Estimasi pengiriman

Dataset mentah tidak disertakan dalam repository untuk menjaga ukuran repository tetap kecil.

---

## Data Warehouse

Data Warehouse menggunakan pendekatan **Star Schema**.

Struktur utama:

                  dim_customer
                       │
                       ▼
  dim_date ───────► fact_sales ◄────── dim_product
                       │
                       └─────────────► dim_seller

### Tabel Dimensi

**1. dim_customer**
Menyimpan informasi pelanggan.
Beberapa atribut utama:
- `customer_sk`
- `customer_unique_id`
- `customer_city`
- `customer_state`
- `customer_zip_code_prefix`

**2. dim_product**
Menyimpan informasi produk.
Beberapa atribut utama:
- `product_sk`
- `product_id`
- `product_category_name`
- `product_weight_g`
- `product_length_cm`
- `product_height_cm`
- `product_width_cm`

**3. dim_seller**
Menyimpan informasi seller.
Beberapa atribut utama:
- `seller_sk`
- `seller_id`
- `seller_city`
- `seller_state`
- `seller_zip_code_prefix`

**4. dim_date**
Merupakan tabel kalender yang digunakan untuk analisis berdasarkan waktu.
Tabel ini mencakup periode: 1 Januari 2016 – 31 Desember 2018
Total: 1.096 baris
Beberapa atribut:
- `date_sk`
- `full_date`
- `day`
- `month`
- `quarter`
- `year`
- `day_name`
- `week`
- `is_weekend`

### Tabel Fakta

**fact_sales**
Merupakan tabel fakta utama yang menyimpan data transaksi penjualan.
Beberapa atribut utama:
- `sales_sk`
- `order_id`
- `order_item_id`
- `customer_sk`
- `product_sk`
- `seller_sk`
- `order_date_sk`
- `delivered_date_sk`
- `estimated_delivery_date_sk`
- `order_status`
- `price`
- `freight_value`
- `total_item_value`
- `delivery_days`
- `is_late`

---

## Proses ETL

Proses ETL dibuat menggunakan Pentaho Data Integration.
Tahapan utama:

    Data Olist
        │
        ▼
    Extract
        │
        ▼
    Transform
        │
        ├── Customer
        ├── Product
        ├── Seller
        ├── Date
        └── Sales
        │
        ▼
    Load
        │
        ▼
    MySQL Data Warehouse

### Transformasi Pentaho
Repository berisi beberapa transformation dan satu job utama.

**Dimension**
- `TR_Dim_Customer.ktr`
- `TR_Dim_Product.ktr`
- `TR_Dim_Seller.ktr`

**Fact**
- `TR_Fact_Sales.ktr`

**Job**
- `JOB_Olist_ETL.kjb`

Job digunakan untuk menjalankan proses ETL secara terstruktur.

### Hasil Proses ETL
Hasil akhir proses ETL:

| Tabel | Jumlah Data |
|---|---|
| dim_customer | 96.096 |
| dim_product | 32.951 |
| dim_seller | 3.095 |
| dim_date | 1.096 |
| fact_sales | 112.650 |

---

## Validasi Data

Validasi dilakukan setelah proses ETL selesai.
Beberapa pemeriksaan yang dilakukan:
- Jumlah data pada setiap tabel.
- Duplikasi business key.
- Nilai NULL pada business key.
- Orphan record pada tabel fakta.
- Total penjualan.
- Total pendapatan.
- Total biaya pengiriman.
- Jumlah pesanan.
- Jumlah item.
- Performa pengiriman.

### Hasil Validasi Utama

| Metrik | Hasil |
|---|---|
| Total Sales | Rp15.843.553,24 |
| Total Revenue | Rp13.591.643,70 |
| Total Freight | Rp2.251.909,54 |
| Total Orders | 98.666 |
| Total Items | 112.650 |
| Delivered Items | 110.196 |
| Late Items | 8.715 |
| Late Percentage | 7,91% |

Validasi relasi antara tabel fakta dan tabel dimensi juga menunjukkan tidak terdapat orphan record pada customer, product, maupun seller.

---

## Power BI Dashboard

Data Warehouse kemudian dihubungkan ke Microsoft Power BI untuk proses analisis dan visualisasi.
Model Power BI menggunakan lima tabel utama:
- `dim_customer`
- `dim_date`
- `dim_product`
- `dim_seller`
- `fact_sales`

### Dashboard 1 — Executive Overview
Halaman pertama digunakan untuk memberikan gambaran umum kondisi penjualan dan operasional.
KPI yang ditampilkan:
- Total Sales
- Total Orders
- Total Revenue
- Delivered Items
- Late Percentage

Visualisasi yang digunakan:
- Monthly Sales Trend
- Top 10 Product Categories by Sales
- Order Status Distribution
- Average Delivery Days by Month
- Delivery Performance
- Top 10 Sellers by Sales
- Sales by Customer State
- Top 10 Customers by Sales

*(Tampilan Dashboard)*

### Dashboard 2 — Operational Analysis
Halaman kedua digunakan untuk analisis operasional yang lebih detail.
Dashboard menyediakan filter berdasarkan tahun sehingga pengguna dapat mengeksplorasi data berdasarkan periode.

*(Tampilan Dashboard)*

---

## Analisis dan Business Insight

### Penjualan
Total nilai penjualan yang dihitung dari `total_item_value` adalah:
**Rp15.843.553,24**
Nilai tersebut merupakan gabungan antara harga produk dan biaya pengiriman.

### Pesanan
Jumlah order unik yang terdapat pada Data Warehouse adalah:
**98.666 order**
Sedangkan jumlah item transaksi adalah:
**112.650 item**
Perbedaan tersebut terjadi karena satu order dapat memiliki lebih dari satu item.

### Produk
Kategori produk dengan penjualan tertinggi pada dashboard antara lain:
- beleza_saude
- relogios_presentes
- cama_mesa_banho

Informasi tersebut dapat digunakan untuk melihat kategori produk yang memberikan kontribusi besar terhadap nilai penjualan.

### Pelanggan
Analisis berdasarkan provinsi menunjukkan bahwa SP (São Paulo) memiliki nilai penjualan tertinggi dibandingkan provinsi lainnya.
Provinsi dengan kontribusi penjualan besar lainnya antara lain:
- RJ
- MG

### Pengiriman
Dari 110.196 item yang memiliki informasi performa pengiriman:
- 101.481 item tepat waktu
- 8.715 item terlambat

Persentasenya:
- Tepat waktu: 92,09%
- Terlambat: 7,91%

Sebanyak 2.454 item tidak memiliki nilai status pengiriman sehingga tidak dimasukkan dalam perhitungan performa pengiriman.

### Status Pesanan
Dashboard menunjukkan bahwa status *delivered* mendominasi distribusi status pesanan.
Distribusi status dapat dianalisis secara interaktif melalui visual Order Status Distribution pada dashboard Power BI.

---

## Struktur Repository

    olist-ecommerce-data-warehouse/
    │
    ├── docs/
    │   └── images/
    │       ├── executive-overview.png
    │       └── operational-analysis.png
    │
    ├── pentaho/
    │   ├── jobs/
    │   │   └── JOB_Olist_ETL.kjb
    │   │
    │   └── transformations/
    │       ├── TR_Dim_Customer.ktr
    │       ├── TR_Dim_Product.ktr
    │       ├── TR_Dim_Seller.ktr
    │       └── TR_Fact_Sales.ktr
    │
    ├── powerbi/
    │   └── Olist_Ecommerce_Dashboard.pbix
    │
    ├── sql/
    │   ├── create_database.sql
    │   ├── create_tables.sql
    │   └── validation.sql
    │
    ├── .gitignore
    └── README.md


---

## Cara Menjalankan Project

### 1. Menyiapkan Database
Buat database menggunakan file:
`sql/create_database.sql`

Kemudian buat struktur tabel menggunakan:
`sql/create_tables.sql`

### 2. Menyiapkan Dataset
Download dataset Brazilian E-Commerce Public Dataset by Olist dari sumber resminya.
File CSV kemudian digunakan sebagai input pada transformation Pentaho.

### 3. Menjalankan ETL
Buka Pentaho Data Integration (Spoon).
Transformation berada di:
`pentaho/transformations/`

Job utama berada di:
`pentaho/jobs/JOB_Olist_ETL.kjb`

Jalankan job untuk memproses data hingga masuk ke Data Warehouse.

### 4. Melakukan Validasi
Gunakan:
`sql/validation.sql`
untuk memeriksa hasil proses ETL.

### 5. Membuka Dashboard
Buka file:
`powerbi/Olist_Ecommerce_Dashboard.pbix`

Kemudian sesuaikan koneksi database apabila diperlukan.

---

## Catatan Power BI

Model Power BI menggunakan `dim_date` sebagai tabel tanggal utama.
Relasi tanggal pada `fact_sales` terdiri dari:
- order date
- delivered date
- estimated delivery date

Relasi *order date* digunakan sebagai relasi aktif utama.
Relasi *tanggal pengiriman* dan *estimasi* digunakan sebagai relasi tidak aktif untuk menghindari *ambiguity* pada model.
Analisis berdasarkan tanggal tersebut dapat dikembangkan menggunakan fungsi DAX seperti `USERELATIONSHIP`.

---

## Skills yang Dipraktikkan

Project ini digunakan untuk mempraktikkan beberapa kemampuan Data Engineer dan Business Intelligence, antara lain:
- SQL
- Data Warehouse
- Star Schema
- ETL
- Pentaho Data Integration
- Data Cleaning
- Data Validation
- Data Modeling
- MySQL / MariaDB
- DAX
- Power BI
- Business Intelligence
- Git & GitHub

---

## Kesimpulan

Project ini menghasilkan pipeline sederhana dari data mentah e-commerce hingga menjadi Data Warehouse dan dashboard Business Intelligence.
Pipeline yang dibangun mencakup:

    Raw Data
       ↓
    Pentaho ETL
       ↓
    Data Warehouse
       ↓
    Data Validation
       ↓
    Power BI
       ↓
    Business Insight

Project ini menunjukkan penerapan proses Data Engineering secara end-to-end, mulai dari pengolahan data, pembangunan Data Warehouse, validasi kualitas data, hingga penyajian data dalam bentuk dashboard interaktif.