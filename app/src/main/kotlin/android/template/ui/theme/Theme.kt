package android.template.ui.theme

import android.app.Activity
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

private val DarkColorScheme  = darkColorScheme(
    primary   = Purple80,
    secondary = PurpleGrey80,
    tertiary  = Pink80,
)

private val LightColorScheme = lightColorScheme(
    primary   = Purple40,
    secondary = PurpleGrey40,
    tertiary  = Pink40,
)

@Composable
fun AndroidTemplateTheme(
    darkTheme:    Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = true,
    content: @Composable () -> Unit,
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }

        darkTheme                                                      -> DarkColorScheme
        else                                                           -> LightColorScheme
    }

    val view = LocalView.current

    if (!view.isInEditMode)
        SideEffect {
            val window                  = (view.context as Activity).window
            val windowsInsetsController = WindowCompat.getInsetsController(window, view)

            window.statusBarColor     = colorScheme.primary.toArgb()
            window.navigationBarColor = colorScheme.inversePrimary.toArgb()

            windowsInsetsController.isAppearanceLightStatusBars     = darkTheme
            windowsInsetsController.isAppearanceLightNavigationBars = darkTheme
        }

    MaterialTheme(
        colorScheme = colorScheme,
        typography  = typography,
        content     = content,
    )
}