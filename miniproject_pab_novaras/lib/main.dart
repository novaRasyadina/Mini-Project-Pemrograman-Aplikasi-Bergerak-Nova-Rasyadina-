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

// ── MODEL ────────────────────────────────────────────────
class Journal {
  String title, date, content, mood;
  Journal({required this.title, required this.date, required this.content, this.mood = '😊'});
}

// ── APP ──────────────────────────────────────────────────
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

// ── HOME SCREEN ──────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Journal> _list = [];

  void _goToForm([Journal? j, int? i]) async {
    final res = await Get.to(
      () => FormScreen(journal: j, index: i),
      transition: Transition.downToUp,
    );
    if (res is Map) {
      setState(() {
        if (res['update'] == true) {
          _list[res['i']] = res['j'];
        } else {
          _list.insert(0, res['j']);
        }
      });
    }
  }

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

  @override
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

// ── FORM SCREEN ──────────────────────────────────────────
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
                            // ignore: deprecated_member_use
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
                        // ignore: deprecated_member_use
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
                  // ignore: deprecated_member_use
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
              // ignore: deprecated_member_use
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
  }
}