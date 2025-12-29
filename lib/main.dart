import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/theme.dart';
import 'screens/screens.dart';
import 'models/models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MengSparkApp());
}

class MengSparkApp extends StatelessWidget {
  const MengSparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MengSpark',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _buildRoute(const HomeScreen(), settings);
          
          // LEARN Mode Routes
          case '/founder-list':
            return _buildRoute(const FounderListScreen(), settings);
          case '/founder-intro':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              FounderIntroScreen(founderId: args['founderId'] as String),
              settings,
            );
          case '/decision':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              DecisionScreen(
                founderId: args['founderId'] as String,
                decisionIndex: args['decisionIndex'] as int,
              ),
              settings,
            );
          case '/reveal':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              RevealScreen(
                founderId: args['founderId'] as String,
                decisionIndex: args['decisionIndex'] as int,
                userChoice: args['userChoice'] as int,
              ),
              settings,
              fadeTransition: true,
            );
          case '/score':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              ScoreScreen(
                founderId: args['founderId'] as String,
                results: List<bool>.from(args['results'] as List),
              ),
              settings,
              fadeTransition: true,
            );
          
          // PLAY Gateway Routes
          case '/business-setup':
            return _buildRoute(const BusinessSetupScreen(), settings);
          case '/module-select':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              ModuleSelectScreen(businessSetup: args['businessSetup'] as BusinessSetup),
              settings,
            );
          case '/flashcards':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              FlashcardsScreen(
                moduleId: args['moduleId'] as String,
                businessSetup: args['businessSetup'] as BusinessSetup,
              ),
              settings,
              slideFromBottom: true,
            );
          case '/ai-quiz':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              AIQuizScreen(
                businessSetup: args['businessSetup'] as BusinessSetup,
                completedModules: List<String>.from(args['completedModules'] as List),
              ),
              settings,
            );
          case '/gateway-result':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              GatewayResultScreen(
                passed: args['passed'] as bool,
                score: args['score'] as int,
                businessSetup: args['businessSetup'] as BusinessSetup,
              ),
              settings,
              fadeTransition: true,
            );
          
          // PLAY Simulation Routes
          case '/simulation-game':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              SimulationGameScreen(businessSetup: args['businessSetup'] as BusinessSetup),
              settings,
            );
          case '/simulation-result':
            final args = settings.arguments as Map<String, dynamic>;
            return _buildRoute(
              SimulationResultScreen(
                businessSetup: args['businessSetup'] as BusinessSetup,
                finalState: args['finalState'] as SimulationState,
                deathReason: args['deathReason'] as String?,
              ),
              settings,
              fadeTransition: true,
            );
          
          default:
            return _buildRoute(const HomeScreen(), settings);
        }
      },
    );
  }

  Route<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings, {
    bool fadeTransition = false,
    bool slideFromBottom = false,
  }) {
    if (fadeTransition) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }
    
    if (slideFromBottom) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
    }
    
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => page,
    );
  }
}
