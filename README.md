# E-Randevu 

SwiftUI ile geliştirilmiş, firma ve müşteri tarafını ayrı yöneten bir çevrimiçi randevu uygulamasıdır.  
Uygulama; firma kayıt/giriş, müşteri kayıt/giriş, firma profil görüntüleme, sektör bazlı firma listeleme, randevu oluşturma, randevu listeleme ve bildirim süreçlerini tek mobil uygulama içinde toplamayı amaçlar.

## Proje Amacı

Bu proje, hizmet veren firmalar ile müşterileri dijital ortamda buluşturan bir mobil randevu altyapısı oluşturmak için geliştirilmiştir.  
Kullanıcılar firmaları inceleyebilir, sektör bazlı arama yapabilir, uygun firmalara randevu talebi oluşturabilir ve mevcut randevularını takip edebilir.

## Kullanılan Teknolojiler

- Swift
- SwiftUI
- MVVM mimarisi
- REST API entegrasyonu
- Firebase Cloud Messaging
- UserNotifications
- CoreLocation
- MapKit
- SDWebImageSwiftUI

## Öne Çıkan Özellikler

### Kimlik Doğrulama ve Kullanıcı Akışı
- Firma girişi
- Müşteri girişi
- Firma kaydı
- Müşteri kaydı
- E-posta doğrulama akışı
- Kullanıcı tipine göre yönlendirme

### Firma Tarafı
- Firma profil ekranı
- Firma detay görüntüleme
- Hizmet listesi görüntüleme
- Personel listesi görüntüleme
- Kullanıcı yorumlarını görüntüleme
- Firma randevu listesi
- Randevu durumu güncelleme
- Randevu slotlarını listeleme
- Yeni slot ekleme altyapısı

### Müşteri Tarafı
- Müşteri profil ekranı
- Randevu oluşturma
- Randevu geçmişi / randevu listesi
- Randevu durum takibi

### Keşif ve Listeleme
- Yakındaki firmaları görüntüleme
- Sektöre göre firma filtreleme
- Sektör detay ekranı
- Öne çıkan firmaları listeleme
- Konum tabanlı içerik gösterimi

### Bildirim ve Cihaz Entegrasyonu
- Firebase kurulumu
- Push notification altyapısı
- Cihaz token bilgisini API tarafına gönderme
