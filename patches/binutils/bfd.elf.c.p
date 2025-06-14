--- bfd/elf.c.orig	2013-11-04 16:33:37.000000000 +0100
+++ bfd/elf.c	2013-12-31 13:16:36.446126819 +0100
@@ -1251,6 +1251,7 @@ _bfd_elf_print_private_bfd_data (bfd *ab
 		}
 	      break;
 
+	    case DT_RISCOS_PIC: name ="RISCOS_PIC"; break;
 	    case DT_NEEDED: name = "NEEDED"; stringp = TRUE; break;
 	    case DT_PLTRELSZ: name = "PLTRELSZ"; break;
 	    case DT_PLTGOT: name = "PLTGOT"; break;
@@ -3951,8 +3952,17 @@ _bfd_elf_map_sections_to_segments (bfd *
 	    }
 	  else if (! writable
 		   && (hdr->flags & SEC_READONLY) == 0
+#if 0
+	/* RISC OS: We need separate segments for text & data, but when the
+ 	   data segment immediately follows the text segment, LD insists on
+	   merging them into one. This change forces LD to maintain separate
+	   segments. Perhaps this functionality should be offered as a command
+	   line option. */
 		   && (((last_hdr->lma + last_size - 1) & -maxpagesize)
 		       != (hdr->lma & -maxpagesize)))
+#else
+		  )
+#endif
 	    {
 	      /* We don't want to put a writable section in a read only
 		 segment, unless they are on the same page in memory
