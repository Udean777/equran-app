import { getLocales } from "expo-localization";
import { createInstance } from "i18next";
import { initReactI18next } from "react-i18next";

import en from "./locales/en.json";
import id from "./locales/id.json";

const deviceLanguage = getLocales()[0]?.languageCode ?? "id";
const i18next = createInstance();

void i18next.use(initReactI18next).init({
  resources: { en: { translation: en }, id: { translation: id } },
  lng: deviceLanguage === "en" ? "en" : "id",
  fallbackLng: "id",
  interpolation: { escapeValue: false },
});

export { i18next };
