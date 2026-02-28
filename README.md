# Mini Project Pemrograman Aplikasi Bergerak

### Deskripsi Aplikasi 
Aplikasi Daily Jurnal atau Jurnal Harian ini dibuat untuk mencatat pikiran, perasaan, kejadian sehari-hari layaknya sebuah buku harian (diary)
tetapi dalam bentuk digital. aplikasi ini dibuat dengan tampilan yang hangat dan mudah digunakan. pengguna dapat menambahkan jurnal baru setiap hari,
melihat semua jurnal yang sudah dibuat sebelumnya, mengedit jurnal yang sudah ada, serta menghapus jurnal yang sudah tidak dibutuhkan dengan cara 
swipe jurnal ke arah kiri menggunakan kursor. setiap jurnal dilengkapi dengan tanggal, judul, isi tulisan panjang, dan pilihan mood berupa emoji.

### Fitur Pada Aplikasi Daily Journal
Fitur-fitur yang ada dalam aplikasi daily journal meliputi 
* create yaitu menambahkan entri baru melalui form yang ada pada fitur "Click Here"
* Read: melihat semua jurnl yang dibuat
* Update: mengubah atau mengedit jurnal yang sudah dibuat sebelumnya dengan cara tap pada kotak daftar jurnal yang
  ingin dihapus
* Delete: Menhgapus jurnal dengan cara swipe ke kiri pada jurnal yang ingin di hapus.
* Undo Delete: Fotur batalkan oenghapusan melalui tombol undo yang muncul setelah melakukan penghapusan di snackbar
* Mood Tracker: Pengguna dapat memilih emoji berdasarkan suasana hati/mood saat menulis jurnal atau catatan harian
* Tanggal: memilih ttanggal menggunakan kalender otomatis.
* Snackbar Notifikasi: Memunculkan notifikasi konfirmasi hapus dengan GetX snackbar.


### Widget Yang Digunakan 

#### Widget Struktur & Layout:
* GetMaterialApp sebagai root aplikasi dengan GetX
* Scaffold sebagai struktur dasar halaman (body, FAB)
* SafeArea untuk mencega konten tertutup status bar
* Column untuk menyusun widget secara vertikal
* Row untuk menyusun widget secara horizontal
* Expanded untuk mengisi sisa ruang yang tersedia
* Spacer untuk mendorong widget ke ujung dalam Row/Column
* SizedBox Memberikan jarak /ukuran tetap
* padding menambahkan padding di sekeliling widget
* SingleChildScrollView membuat konten agar dapat di scroll

#### Widget Tampilan:
* Container yaitu widget dengan dekorasi warna, shadow, border radius.
* Card yaitu kartu dengan shadow bawaan material
* Text untuk menampilkan teks
* Icon untuk menampilkan ikon material
* Divider yaitu garis pemisah horizontal
* AnimatedContainer yaitu container dengan animasi saat properti berubah(src=Blackbox AI ^_^)
#### Widget Input
* Form, yaitu Wrapper form dengan GlobalKey validasi
* TextFormField untuk input teks dengan validator bawaan
* TextEditingController untuk mengontrol dan membaca isi TextField
* GlobalKey<FromState> yaitu kunci untuk mengakses state form (alidasi)
* ShowDatePicker adalah dialog kalender bawaan dari flutter

#### Widget Interaksi:
* GestureDetector untuk mendeteksi gesture tap pada widget
* Dismissible digunakan utnuk widget dihapus dengan swipe
* FloatingActionButton.extended yaitu tombol aksi utama di pojok kanan bawah
* ElevatedButton yaitu tombol dengan efek elevated (mengambang)
* IconButton yaitu tombol berbentuk ikon
* TextButton yaitu tombol teks(dipakai di snackbar UNDO)
* ListView.Builder yaitu daftar item efisien
* ListView adalah daftar item dengan scroll (dipakai mood selector)

#### Widget GetX
* Get.to() untuk Navigasi ke halaman baru
* Get.back() untuk kembali ke halaman sebelumnya dan kirim hasil
* Get.snackbar() untuk menampilkan notifikasi snackbar




  
