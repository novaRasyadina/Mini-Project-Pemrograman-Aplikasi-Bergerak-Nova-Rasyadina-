# Mini Project Pemrograman Aplikasi Bergerak

## Deskripsi Aplikasi 
Aplikasi Daily Jurnal atau Jurnal Harian ini dibuat untuk mencatat pikiran, perasaan, kejadian sehari-hari layaknya sebuah buku harian (diary)
tetapi dalam bentuk digital. aplikasi ini dibuat dengan tampilan yang hangat dan mudah digunakan. pengguna dapat menambahkan jurnal baru setiap hari,
melihat semua jurnal yang sudah dibuat sebelumnya, mengedit jurnal yang sudah ada, serta menghapus jurnal yang sudah tidak dibutuhkan dengan cara 
swipe jurnal ke arah kiri menggunakan kursor. setiap jurnal dilengkapi dengan tanggal, judul, isi tulisan panjang, dan pilihan mood berupa emoji.

## Fitur Pada Aplikasi Daily Journal
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


## Widget Yang Digunakan 

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

## Penjelasan Kode 
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(const MyApp());

// ── COLORS ──────────────────────────────────────────────
const kBg     = Color(0xFFF5F0EB);
const kDark   = Color(0xFF1A1A2E);
const kAccent = Color(0xFFE07A5F); // terracotta
const kCard   = Color(0xFFFFFFFF);
const kMuted  = Color(0xFF9A9A9A);
const kTag    = Color(0xFFFFF0EC);

```
Kode di atas merupakan packahe utama flutter yang menyediakan semua widget material dan wajib di import di setiap file flutter. kemudian package GetX yang digunakan untuk navigasi natar halaman dan menampilkan snackbar, selanjutnya adalah warna-warna yang digunakan di dalam aplikasi yang mengusung tema hangat dengan nuansa cream, coklat, putih, nav, dan teraccota.

```dart
class Journal {
  String title, date, content, mood;
  Journal({required this.title, required this.date, required this.content, this.mood = '😊'});
}

```
journal adalah blueprint yang merepresentasikan satu masukan jurnal. setiap objek jurnal menyimpan empat data: title (judul), date (tanggal format YYYY-MM-DD), content (isi tulisan), dan mood (emoji suasana hati). Parameter title, date, dan content bersifat required artinya wajib diisi saat membuat objek baru. Sedangkan mood bersifat opsional dengan nilai default '😊' jika tidak diisi, otomatis menggunakan emoji senyum.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daily Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'serif'),
      home: const HomeScreen(),
    );
  }
}
```
MyApp menggunkan StatlessWidget karena tidak memiliki data yang berubah yang artinya hanya bertugas mengatur konfigurasi awal. GetMaterialApp digunakan sebagai pengganti MaterialApp biasa agar semua fitur GetX bisa berfungsi di seluruh aplikasi. debugShowCheckedModeBanner: false menyembunyikan banner merah "DEBUG" di pojok layar. Font serif dipilih agar tampilan terasa seperti menulis di buku harian sungguhan, dan home: HomeScreen() menentukan halaman pertama yang dibuka saat aplikasi dijalankan.

```dart
class _HomeScreenState extends State<HomeScreen> {
  final List<Journal> _list = [];

  void _goToForm([Journal? j, int? i]) async {
    final res = await Get.to(
      () => FormScreen(journal: j, index: i),
      transition: Transition.downToUp,
    );
    if (res is Map) {
      setState(() {
        if (res['update'] == true) _list[res['i']] = res['j'];
        else _list.insert(0, res['j']);
      });
    }
  }
```
HomeScreen menggunakan StatefulWidget karena daftar jurnal (_list) bisa berubah sewaktu-waktu akibat aksi tambah, edit, atau hapus — dan setiap perubahan harus membuat UI ikut diperbarui. _list adalah List<Journal> yang dimulai kosong, menjadi tempat penyimpanan semua entri jurnal selama aplikasi berjalan. selanjutnya erdapat fungsi yang menangani dua kondisi sekaligus yaitu 
menambah jurnal baru dan mengedit jurnal lama. [Journal? j, int? i] yang berarti opsional, jika dipanggil tanpa argumen maka mode tambah baru, jika dipanggil dengan data jurnal dan index-nya maka mode edit. await Get.to() membuka FormScreen dan menunggu hasilnya setelah layar ditutup. Jika user menyimpan data, result berisi Map yang diterima sebagai res. Lalu setState() dipanggil untuk memperbarui UI jika mode update, data lama diganti di index yang sama; jika mode tambah, data baru disisipkan di posisi paling atas list.

```dart
void _delete(int i) {
    final j = _list[i];
    setState(() => _list.removeAt(i));
    Get.snackbar('Deleted', j.title,
      backgroundColor: kDark, colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      mainButton: TextButton(
        onPressed: () { setState(() => _list.insert(i, j)); Get.back(); },
        child: const Text('UNDO', style: TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }
```

sebeum menghapus, item yang akan dihapus disimpan dulu ke variabel j. ini penting agar fitur UNDO bisa bekerja dan data tidak benar-benar hilang, hanya dipindah saja dari list, dan dapat dikembalikan jika pengguna tidak jadi menghapus nya. 

```dart
Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(children: [
 // ── HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}',
                  style: const TextStyle(fontSize: 13, color: kAccent, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                ),
                const SizedBox(height: 2),
                const Text('My Journal', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kDark, letterSpacing: -0.8)),
              ]),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(20)),
                child: Text('${_list.length} Journal', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 20),
```

kode diatas adalah untuk membuat tanggal menjadi dapat dipilih secara mudah dan kode selanjurnta adalah untuk mengatur tanggal di tambahkan nya jurnal yang dibuat secara otomatis akan muncul di dalam kotak jurnal yang ditambah agar tangggal dapat terlihat di atasnyta dengan mengatur ke wawrna teracota. pada kode di atas terdapat pula kode untuk membuat tampilan tulisan di awal tampilan aplikasi yaitu My Journal dan berapa jurnal yang sudah dibuat di dalam aplikasi tersebut.

```dart
 // ── LIST JURNAL YANG DITAMBAHKAN
          Expanded(
            child: _list.isEmpty
              ? _empty()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: _list.length,
                  itemBuilder: (_, i) => _card(_list[i], i),
                ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToForm(),
        backgroundColor: kDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Click Here', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
```
Kode di atas yang dimulai dengan Expanded digunakan untuk menaruh list jurnal yang ditambahkan di tampilan apkikasi berbentuk kotak memanjang dengan sudut tumpul. kemudian kode yang dimulai dengan floatingActionButton tersebut digunakan untuk menaruh fitur tambahkan jurnal baru yang bertuliskan "Click Here".

```dart
  Widget _empty() => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(color: kCard, shape: BoxShape.circle),
        child: const Text('📖', style: TextStyle(fontSize: 44)),
      ),
      const SizedBox(height: 20),
      const Text('Start your story', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kDark)),
      const SizedBox(height: 6),
      const Text('write your first journal', style: TextStyle(fontSize: 14, color: kMuted)),
    ]),
  );

  Widget _card(Journal j, int i) {
    final parts = j.date.split('-');
    final months = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return Dismissible(
      key: ValueKey('$i${j.title}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _delete(i),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () => _goToForm(j, i),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(20),
            // ignore: deprecated_member_use
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Date block
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: kTag, borderRadius: BorderRadius.circular(14)),
              child: Column(children: [
                Text(parts.length > 2 ? parts[2] : '',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: kDark, height: 1)),
                Text(parts.length > 1 ? months[int.tryParse(parts[1]) ?? 0] : '',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kAccent, letterSpacing: 0.5)),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(j.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDark),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
                Text(j.mood, style: const TextStyle(fontSize: 20)),
              ]),
              const SizedBox(height: 5),
              Text(j.content,
                style: const TextStyle(fontSize: 13, color: kMuted, height: 1.5),
                maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 10),
              Row(children: [
                // Hint: tap to edit
                Row(children: const [
                  Icon(Icons.touch_app_outlined, size: 12, color: kMuted),
                  SizedBox(width: 3),
                  Text('Tap to edit', style: TextStyle(fontSize: 11, color: kMuted)),
                ]),
                const SizedBox(width: 14),
                // Hint: swipe to delete
                Row(children: const [
                  Icon(Icons.swipe_left_outlined, size: 12, color: kMuted),
                  SizedBox(width: 3),
                  Text('Swipe to delete', style: TextStyle(fontSize: 11, color: kMuted)),
                ]),
              ]),
            ])),
          ]),
        ),
      ),
    );
  }
}
```
_empty() adalah widget yang ditampilkan ketika belum ada jurnal sama sekali, berisi ikon buku dan teks panduan. _card() adalah tampilan setiap penambahan jurnal dalam bentuk kartu. Kartu dibungkus Dismissible agar bisa dihapus dengan swipe ke kiri saat swipe, background merah dengan ikon tempat sampah akan terlihat, dan setelah animasi selesai _delete() dipanggil. Kartu juga dibungkus GestureDetector sehingga ketika di-tap, form edit terbuka.

```dart
class FormScreen extends StatefulWidget {
  final Journal? journal;
  final int? index;
  const FormScreen({super.key, this.journal, this.index});
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title, _date, _content;
  String _mood = '😊';

  final _moods = ['😊','😢','😤','😴','🥰','😰','🤩','😌'];
```
FormScreen digunakan untuk dua keperluan sekaligus, yaitu menambah jurnal baru dan mengedit yang lama. Parameter journal bertanda ? (nullable) jika null berarti mode tambah, jika berisi data berarti mode edit. index menyimpan posisi jurnal di list, digunakan saat update agar data ditulis di tempat yang benar. kemudian adalah kode yang diatur untuk memilih emot sesuai dengan suasana hati pengguna.

```dart
@override
  void initState() {
    super.initState();
    final j = widget.journal;
    _title   = TextEditingController(text: j?.title ?? '');
    _date    = TextEditingController(text: j?.date ?? '');
    _content = TextEditingController(text: j?.content ?? '');
    _mood    = j?.mood ?? '😊';
  }

  @override
  void dispose() {
    _title.dispose(); _date.dispose(); _content.dispose();
    super.dispose();
  }
```
initState() dipanggil sekali saat widget pertama dibuat. Di sini ketiga TextEditingController diinisialisasi, jika mode edit, controller diisi dengan data lama menggunakan operator ?. dan ??; jika mode tambah, diisi string kosong. dispose() wajib dipanggil saat widget dihancurkan untuk melepaskan memori yang dipakai controller. Tanpa ini, akan terjadi memory leak, yaitu kondisi di mana aplikasi tidka dapat mengembalikan memori yang tidak lagi digunakan, karena controller terus menempati memori walaupun layar sudah ditutup.

```dart
  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: kDark)),
        child: child!,
      ),
    );
    if (d != null) _date.text = d.toString().substring(0, 10);
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Get.back(result: {
      'j': Journal(title: _title.text, date: _date.text, content: _content.text, mood: _mood),
      'update': widget.journal != null,
      'i': widget.index,
    });
  }
```
_pickDate() membuka dialog kalender bawaan Flutter. Setelah user memilih tanggal, DateTime yang dikembalikan dikonversi ke format string "YYYY-MM-DD" menggunakan .substring(0, 10), lalu dimasukkan ke controller _date. Pemeriksaan if (d != null) memastikan field tidak berubah jika user menekan cancel. kemudian ada kode _save() pertama-tama menjalankan validasi seluruh form dengan _form.currentState!.validate(). Jika ada field yang kosong, pesan error muncul di bawah field tersebut dan fungsi berhenti. Jika semua valid, Get.back() menutup layar dan mengirimkan data sebagai result berupa Map — berisi objek Journal baru, flag update (true/false), dan index yang akan diterima kembali oleh HomeScreen.

```dart
 @override
  Widget build(BuildContext context) {
    final isEdit = widget.journal != null;
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(children: [
          // ── BAR ATAS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close_rounded, color: kDark),
                style: IconButton.styleFrom(backgroundColor: kCard, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const Spacer(),
              Text(isEdit ? 'Edit Journal' : 'New Journal',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kDark)),
              const Spacer(),
              const SizedBox(width: 48),
            ]),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Form(
                key: _form,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // ── MOOD
                  const Text('How are you feeling?',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kMuted, letterSpacing: 0.4)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView(scrollDirection: Axis.horizontal, children: _moods.map((m) {
                      final sel = m == _mood;
                      return GestureDetector(
                        onTap: () => setState(() => _mood = m),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(right: 8),
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: sel ? kDark : kCard,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
                          ),
                          child: Center(child: Text(m, style: const TextStyle(fontSize: 22))),
                        ),
                      );
                    }).toList()),
                  ),
                  const SizedBox(height: 22),

                  // ── TANGGAL
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
                      child: Row(children: [
                        const Icon(Icons.calendar_today_outlined, size: 18, color: kAccent),
                        const SizedBox(width: 12),
                        Expanded(child: TextFormField(
                          controller: _date,
                          enabled: false,
                          decoration: const InputDecoration(
                            hintText: 'Select date', border: InputBorder.none,
                            isDense: true, contentPadding: EdgeInsets.zero,
                            hintStyle: TextStyle(color: kMuted),
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w600, color: kDark),
                          validator: (v) => v!.isEmpty ? 'Pick a date' : null,
                        )),
                        const Icon(Icons.chevron_right, color: kMuted, size: 18),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── JUDUL
                  TextFormField(
                    controller: _title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: kDark, letterSpacing: -0.8, height: 1.2),
                    decoration: const InputDecoration(
                      hintText: 'Title...', border: InputBorder.none,
                      isDense: true, contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFFCCCCCC), letterSpacing: -0.8),
                    ),
                    validator: (v) => v!.isEmpty ? 'Add a title' : null,
                    maxLines: null,
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.black.withOpacity(0.07)),
                  const SizedBox(height: 12),

                  // ── CONTENT
                  TextFormField(
                    controller: _content,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF3C3C3E), height: 1.8),
                    decoration: const InputDecoration(
                      hintText: "What's on your mind today?\n\nWrite freely — this is your space...  -nov",
                      border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(fontSize: 15, color: Color(0xFFBBBBBB), height: 1.8),
                    ),
                    maxLines: null, minLines: 10,
                    keyboardType: TextInputType.multiline,
                    validator: (v) => v!.isEmpty ? 'Write something' : null,
                  ),
                ]),
              ),
            ),
          ),

          // ── SAVE BUTTON(SIMPAN)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
            ),
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
            child: SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDark, foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(isEdit ? 'Update Journal' : 'Save Journal',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ]),
      ),
    );
```
Kode di atas adalah bagian build() dari FormScreen, yaitu layar untuk menambah atau mengedit jurnal. Variabel isEdit dibuat di awal untuk menentukan mode layar yang nilainya true jika sedang mengedit, false jika tambah baru. Variabel ini digunakan untuk mengubah judul halaman dan teks tombol simpan tanpa perlu membuat dua layar terpisah. Struktur layar dibagi menjadi tiga bagian. Top bar berisi tombol X untuk kembali tanpa menyimpan dan judul halaman di tengah. Konten form dibungkus SingleChildScrollView agar bisa di scroll ketika keyboard muncul. Tombol simpan diletakkan di luar scroll area agar selalu terlihat di bagian bawah layar. Di dalam form terdapat empat input. Mood selector menampilkan deretan emoji horizontal, nantinya emoji yang dipilih berubah warna dengan animasi 180ms. TextField tanggal di-set enabled, false sehingga pengisian hanya bisa dilakukan lewat date picker. TextField judul menggunakan font besar agar terasa seperti menulis judul buku harian. TextField isi jurnal memiliki tinggi minimalnya 10 baris dan bisa terus membesar sesuai panjang tulisan. Ketiga TextFormField memiliki validator masing-masing. Jika ada field yang kosong saat tombol ditekan, pesan error akan muncul. Jika semua terisi, fungsi _save() dipanggil untuk mengirim data kembali ke HomeScreen.

## Dokumentasi Aplikasi Daily Journal

  
