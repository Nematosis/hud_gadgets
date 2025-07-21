//Funciones para encripcion de datos

public class AESUtil {

  public SecretKey generateKey(){
    try {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256); // Para AES-256
        return keyGen.generateKey();
    } catch (Exception e) {
        throw new RuntimeException("Error al generar la clave AES", e);
    }
  }

  public String encrypt(String plainText, SecretKey secretKey){
    try {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] iv = new byte[16]; // AES utiliza un tamaño de bloque de 16 bytes
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);

        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivParameterSpec);
        byte[] encryptedBytes = cipher.doFinal(plainText.getBytes());
        
        byte[] encryptedIVAndText = new byte[iv.length + encryptedBytes.length];
        System.arraycopy(iv, 0, encryptedIVAndText, 0, iv.length);
        System.arraycopy(encryptedBytes, 0, encryptedIVAndText, iv.length, encryptedBytes.length);

        return Base64.getEncoder().encodeToString(encryptedIVAndText);
    } catch (Exception e) {
        throw new RuntimeException("Error al encriptar el texto", e);
    }
  }
  
  public String[] encrypt(String[] text, SecretKey K){
    String[] cipher = new String[text.length];
    for(int i = 0;i < text.length;i++){  cipher[i] = encrypt(text[i],K);  }
    return cipher;
  }

  public String decrypt(String encryptedIvText, SecretKey secretKey) {
    try {
        byte[] ivAndEncryptedText = Base64.getDecoder().decode(encryptedIvText);
        byte[] iv = new byte[16];
        System.arraycopy(ivAndEncryptedText, 0, iv, 0, iv.length);
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);

        int encryptedSize = ivAndEncryptedText.length - iv.length;
        byte[] encryptedBytes = new byte[encryptedSize];
        System.arraycopy(ivAndEncryptedText, iv.length, encryptedBytes, 0, encryptedSize);

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, secretKey, ivParameterSpec);
        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

        return new String(decryptedBytes);
    } catch (Exception e) {
        throw new RuntimeException("Error al desencriptar el texto", e);
    }
  }
  
  public String[] decrypt(String[] text, SecretKey K){
    String[] cipher = new String[text.length];
    for(int i = 0;i < text.length;i++){  cipher[i] = decrypt(text[i],K);  }
    return cipher;
  }
  
  public String encryptImage(File imageFile, SecretKey secretKey) {
    try {
        // Leer la imagen en un BufferedImage
        BufferedImage originalImage = ImageIO.read(imageFile);

        // Convertir BufferedImage a ByteArrayOutputStream
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(originalImage, "png", baos); // png para evitar pérdida de calidad
        byte[] imageBytes = baos.toByteArray();

        // Convertir el arreglo de bytes de la imagen a un String para encriptar
        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
        // Encriptar la imagen
        return encrypt(base64Image, secretKey);
    } catch (IOException e) {
        throw new RuntimeException("Error al leer o procesar la imagen", e);
    }
  }

  public BufferedImage decryptImage(String encryptedImageData, SecretKey secretKey) {
    try {
        // Desencriptar la cadena de texto encriptada para obtener los bytes de la imagen
        String decryptedBase64Image = decrypt(encryptedImageData, secretKey);
        byte[] imageBytes = Base64.getDecoder().decode(decryptedBase64Image);

        // Convertir los bytes de la imagen de vuelta en un BufferedImage
        ByteArrayInputStream bais = new ByteArrayInputStream(imageBytes);
        return ImageIO.read(bais);
    } catch (IOException e) {
        throw new RuntimeException("Error al desencriptar o procesar la imagen", e);
    }
  }

  public void saveDecryptedImage(BufferedImage image, String path) {
    try {
        File outputfile = new File(path);
        ImageIO.write(image, "png", outputfile); // Guardar como PNG
    } catch (IOException e) {
        throw new RuntimeException("Error al guardar la imagen", e);
    }
  }

  public PImage decryptImageToPImage(String encryptedImageData, SecretKey secretKey) {
    BufferedImage decryptedImage = decryptImage(encryptedImageData, secretKey);
    return bufferedImageToPImage(decryptedImage);
  }
  
  private PImage bufferedImageToPImage(BufferedImage bImage) {
    PImage pimg = new PImage(bImage.getWidth(), bImage.getHeight(), PImage.ARGB);
    bImage.getRGB(0, 0, pimg.width, pimg.height, pimg.pixels, 0, pimg.width);
    pimg.updatePixels();
    return pimg;
  }
  
  public void saveKey(SecretKey a, String pass, String code) {
    try {
        KeyStore keyStore = KeyStore.getInstance("JCEKS");
        char[] password = pass.toCharArray();

        keyStore.load(null, password);
        
        KeyStore.SecretKeyEntry secretKeyEntry = new KeyStore.SecretKeyEntry(a);
        keyStore.setEntry(code, secretKeyEntry, new KeyStore.PasswordProtection(password));

        try (FileOutputStream fos = new FileOutputStream(dataPath("/Misc/Dir/OWN/scl.jceks"))) {
            keyStore.store(fos, password);
        }
    }catch(KeyStoreException | NoSuchAlgorithmException | CertificateException | IOException e) {
        e.printStackTrace();
    }
  }
  
  public SecretKey loadKey(String path, String pass, String alias) {
    try {
      KeyStore keyStore = KeyStore.getInstance("JCEKS"); // O el tipo de keystore que estés utilizando
      char[] password = pass.toCharArray();
      
      try (FileInputStream fis = new FileInputStream(path)) {
          keyStore.load(fis, password);
      }

      KeyStore.SecretKeyEntry secretKeyEntry = (KeyStore.SecretKeyEntry) keyStore.getEntry(alias, new KeyStore.PasswordProtection(password));
      return secretKeyEntry.getSecretKey();
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////IMAGE ESTEGANOGRAPHY
public void TLCrypt(String datos, String directorio){
  PImage core;
  // Convertir los datos en un arreglo de bytes
  byte[] dataBytes = datos.getBytes();
  int totalBytes = dataBytes.length;

  // Calcular el tamaño de la imagen necesaria
  int totalBits = totalBytes * 8; // Cada byte tiene 8 bits
  int pixelsNeeded = (int) Math.ceil(totalBits / 32.0); // 32 bits por píxel
  int imageSize = (int) Math.ceil(Math.sqrt(pixelsNeeded));
  core = createImage(imageSize,imageSize,ARGB);
  core.loadPixels();

  for(int i = 0;i < totalBytes;i+=4){
    core.pixels[i/4] = color((i<totalBytes)?int(dataBytes[i]):0
                          ,((i+1)<totalBytes)?int(dataBytes[i+1]):0
                          ,((i+2)<totalBytes)?int(dataBytes[i+2]):0
                          ,((i+3)<totalBytes)?int(dataBytes[i+3]):0);
  }
  
  core.updatePixels();
  core.save(directorio + "/composite.tif");
}

public String TLDecrypt(String directorio) {
  try {
      PImage core = loadImage(directorio + "/composite.tif");
      core.loadPixels();

      ByteArrayOutputStream byteStream = new ByteArrayOutputStream();

      for (int i = 0; i < core.pixels.length; i++) {
        // Obtener los colores de cada píxel
        int pixel = core.pixels[i];
        int red = (pixel >> 16) & 0xFF;
        int green = (pixel >> 8) & 0xFF;
        int blue = pixel & 0xFF;
        int alpha = (pixel >> 24) & 0xFF;

        // Agregar los colores al stream de bytes
        byteStream.write(new byte[] {(byte) red, (byte) green, (byte) blue, (byte) alpha});
      }

      // Convertir el stream de bytes a una cadena
      return new String(byteStream.toByteArray()).trim();
  }catch(Exception e){  e.printStackTrace();  return null;  }
}

public void saveLeute(String code,String data){
  
}
