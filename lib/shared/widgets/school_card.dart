import 'package:flutter/material.dart';
// 1. PASTIKAN IMPORT INI ADA
import 'package:google_fonts/google_fonts.dart'; 
import '../../models/instansi_model.dart';

class SchoolCard extends StatelessWidget {
  final InstansiModel instansi;
  final VoidCallback? onTap;

  const SchoolCard({super.key, required this.instansi, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: instansi.thumbnailUrl != null 
                ? Image.network(
                    instansi.thumbnailUrl!,
                    width: 100, 
                    height: 100, 
                    fit: BoxFit.cover,
                    // Tambahkan loading builder agar lebih smooth
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildPlaceholder();
                    },
                    errorBuilder: (ctx, _, __) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
            ),
            
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          instansi.nama,
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.baloo2(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            color: const Color(0xFF3577E5)
                          ),
                        ),
                      ),
                      _buildRatingBadge(instansi.rating),
                    ],
                  ),

                  Text(
                    instansi.biayaDisplay, 
                    style: GoogleFonts.baloo2(
                      color: const Color(0xFF3577E5), 
                      fontWeight: FontWeight.w700, 
                      fontSize: 14
                    )
                  ),
                  const SizedBox(height: 6),

                  if (instansi.isPopular) _buildPopularBadge(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Color(0xFF3577E5)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          instansi.alamat, 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis, 
                          style: GoogleFonts.baloo2(
                            color: Colors.grey[600], 
                            fontSize: 12, 
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() => Container(
    width: 100, 
    height: 100, 
    color: Colors.grey[200], 
    child: const Icon(Icons.image, color: Colors.grey)
  );

  Widget _buildPopularBadge() => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFF4CD964), 
      borderRadius: BorderRadius.circular(8)
    ),
    // Hapus 'const' di sini karena Row memiliki widget dinamis
    child: Row(
      mainAxisSize: MainAxisSize.min, 
      children: const [
        Icon(Icons.verified_rounded, color: Colors.white, size: 14),
        SizedBox(width: 4),
        Text(
          "Terpopuler", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)
        ),
      ],
    ),
  );

  Widget _buildRatingBadge(double rating) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(12), 
      border: Border.all(color: Colors.grey.shade200)
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: Colors.amber, size: 16), 
        const SizedBox(width: 4), 
        Text(
          rating.toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}