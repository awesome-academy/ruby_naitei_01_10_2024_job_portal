let translations = {};

async function loadTranslations(locale) {
  try {
    const response = await fetch(`/translations/${locale}`);
    if (!response.ok) {
      throw new Error("Failed to load translations");
    }
    translations = await response.json();
  } catch (error) {
    console.error("Error loading translations:", error);
  }
}

function t(key) {
  return translations[key] || `[Missing: ${key}]`;
}

export { loadTranslations, t };
